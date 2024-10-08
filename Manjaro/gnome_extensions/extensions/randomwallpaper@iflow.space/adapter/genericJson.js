import * as JSONPath from './../jsonPath.js';
import * as SettingsModule from './../settings.js';
import * as Utils from './../utils.js';
import {BaseAdapter} from './../adapter/baseAdapter.js';
import {HistoryEntry} from './../history.js';
import {Logger} from './../logger.js';


/** How many times the service should be queried at maximum. */
const MAX_SERVICE_RETRIES = 5;

/**
 * How many times we should try to get a new image from an array.
 * No new request are being made.
 */
const MAX_ARRAY_RETRIES = 5;

/**
 * Adapter for generic JSON image sources.
 */
class GenericJsonAdapter extends BaseAdapter {
    /**
     * Create a new generic json adapter.
     *
     * @param {string} id Unique ID
     * @param {string} name Custom name of this adapter
     */
    constructor(id, name) {
        super({
            defaultName: 'Generic JSON Source',
            id,
            name,
            schemaID: SettingsModule.RWG_SETTINGS_SCHEMA_SOURCES_GENERIC_JSON,
            schemaPath: `${SettingsModule.RWG_SETTINGS_SCHEMA_PATH}/sources/genericJSON/${id}/`,
        });
    }

    /**
     * Retrieves new URLs for images and crafts new HistoryEntries.
     *
     * @param {number} count Number of requested wallpaper
     * @returns {HistoryEntry[]} Array of crafted HistoryEntries
     * @throws {HistoryEntry[]} Array of crafted historyEntries, can be empty
     */
    async _getHistoryEntry(count) {
        const wallpaperResult = [];

        let url = this._settings.getString('request-url');
        url = encodeURI(url);
        const message = this._bowl.newGetMessage(url);

        if (message === null) {
            Logger.error('Could not create request.', this);
            throw wallpaperResult;
        }

        let response_body;

        try {
            const response_body_bytes = await this._bowl.send_and_receive(message);
            response_body = JSON.parse(new TextDecoder().decode(response_body_bytes));
        } catch (error) {
            Logger.error(error, this);
            throw wallpaperResult;
        }

        const imageJSONPath = this._settings.getString('image-path');
        const postJSONPath = this._settings.getString('post-path');
        const domainUrl = this._settings.getString('domain');
        const authorNameJSONPath = this._settings.getString('author-name-path');
        const authorUrlJSONPath = this._settings.getString('author-url-path');

        for (let i = 0; i < MAX_ARRAY_RETRIES + count && wallpaperResult.length < count; i++) {
            const [returnObject, resolvedPath] = JSONPath.getTarget(response_body, imageJSONPath);

            if (!returnObject || (typeof returnObject !== 'string' && typeof returnObject !== 'number') || returnObject === '') {
                Logger.error('Unexpected json member found', this);
                break;
            }

            const imageDownloadUrl = this._settings.getString('image-prefix') + String(returnObject);
            const imageBlocked = this._isImageBlocked(Utils.fileName(imageDownloadUrl));


            // Don't retry without @random present in JSONPath
            if (imageBlocked && !imageJSONPath.includes('@random')) {
                // Abort and try again
                break;
            }

            if (imageBlocked)
                continue;


            // A bit cumbersome to handle "unknown" in the following parts:
            // https://github.com/microsoft/TypeScript/issues/27706
            let postUrl;

            const postUrlObject = JSONPath.getTarget(response_body, JSONPath.replaceRandomInPath(postJSONPath, resolvedPath))[0];

            if (typeof postUrlObject === 'string' || typeof postUrlObject === 'number')
                postUrl = this._settings.getString('post-prefix') + String(postUrlObject);
            else
                postUrl = '';

            let authorName = null;

            const authorNameObject = JSONPath.getTarget(response_body, JSONPath.replaceRandomInPath(authorNameJSONPath, resolvedPath))[0];

            if (typeof authorNameObject === 'string' && authorNameObject !== '')
                authorName = authorNameObject;

            let authorUrl;

            const authorUrlObject = JSONPath.getTarget(response_body, JSONPath.replaceRandomInPath(authorUrlJSONPath, resolvedPath))[0];

            if (typeof authorUrlObject === 'string' || typeof authorUrlObject === 'number')
                authorUrl = this._settings.getString('author-url-prefix') + String(authorUrlObject);
            else
                authorUrl = '';

            const historyEntry = new HistoryEntry(authorName, this._sourceName, imageDownloadUrl);

            if (authorUrl !== '')
                historyEntry.source.authorUrl = authorUrl;

            if (postUrl !== '')
                historyEntry.source.imageLinkUrl = postUrl;

            if (domainUrl !== '')
                historyEntry.source.sourceUrl = domainUrl;

            if (!this._includesWallpaper(wallpaperResult, historyEntry.source.imageDownloadUrl))
                wallpaperResult.push(historyEntry);
        }

        if (wallpaperResult.length < count) {
            Logger.warn('Returning less images than requested.', this);
            throw wallpaperResult;
        }

        return wallpaperResult;
    }

    /**
     * Retrieves new URLs for images and crafts new HistoryEntries.
     *
     * Can internally query the request URL multiple times because it's unknown how many images will be reported back.
     *
     * @param {number} count Number of requested wallpaper
     * @returns {HistoryEntry[]} Array of crafted HistoryEntries
     * @throws {HistoryEntry[]} Array of crafted historyEntries, can be empty
     */
    async requestRandomImage(count) {
        const wallpaperResult = [];

        for (let i = 0; i < MAX_SERVICE_RETRIES + count && wallpaperResult.length < count; i++) {
            let historyArray = [];

            try {
                // This should run sequentially
                // eslint-disable-next-line no-await-in-loop
                historyArray = await this._getHistoryEntry(count);
            } catch (error) {
                Logger.warn('Failed getting image', this);

                if (Array.isArray(error) && error.length > 0 && error[0] instanceof HistoryEntry)
                    historyArray = error;

                // Do not escalate yet, try again
            } finally {
                historyArray.forEach(element => {
                    if (!this._includesWallpaper(wallpaperResult, element.source.imageDownloadUrl))
                        wallpaperResult.push(element);
                });
            }

            // Image blocked, try again
        }

        if (wallpaperResult.length < count) {
            Logger.warn('Returning less images than requested.', this);
            throw wallpaperResult;
        }

        return wallpaperResult;
    }
}

export {GenericJsonAdapter};
