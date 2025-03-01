import Gio from 'gi://Gio';
import * as SettingsModule from './../settings.js';
import {Logger} from './../logger.js';
import {SoupBowl} from './../soupBowl.js';

/**
 * Abstract base adapter for subsequent classes to implement.
 */
class BaseAdapter {
    /**
     * Create a new base adapter.
     *
     * Exposes settings and utilities for subsequent classes.
     * Previously saved settings will be used if the ID matches.
     *
     * @param {object} params Parameter object with settings
     * @param {string} params.defaultName Default adapter name
     * @param {string} params.id Unique ID
     * @param {string | null} params.name Custom name, falls back to the default name on null
     * @param {string} params.schemaID ID of the adapter specific schema ID
     * @param {string} params.schemaPath Path to the adapter specific settings schema
     */
    constructor(params) {
        this._bowl = new SoupBowl();
        const path = `${SettingsModule.RWG_SETTINGS_SCHEMA_PATH}/sources/general/${params.id}/`;
        this._settings = new SettingsModule.Settings(params.schemaID, params.schemaPath);
        this._sourceName = params.name ?? params.defaultName;
        this._generalSettings = new SettingsModule.Settings(SettingsModule.RWG_SETTINGS_SCHEMA_SOURCES_GENERAL, path);
    }

    /**
     * Fetches an image according to a given HistoryEntry.
     *
     * This default implementation requests the image in HistoryEntry.source.imageDownloadUrl
     * using Soup and saves it to HistoryEntry.path
     *
     * @param {HistoryEntry} historyEntry The historyEntry to fetch
     * @returns {Promise<HistoryEntry>} unaltered HistoryEntry
     */
    async fetchFile(historyEntry) {
        const file = Gio.file_new_for_path(historyEntry.path);
        const fstream = file.replace(null, false, Gio.FileCreateFlags.NONE, null);

        // craft new message from details
        const request = this._bowl.newGetMessage(historyEntry.source.imageDownloadUrl);

        // start the download
        const response_data_bytes = await this._bowl.send_and_receive(request);

        if (!response_data_bytes) {
            fstream.close(null);
            throw new Error('Not a valid image response');
        }

        fstream.write(response_data_bytes, null);
        fstream.close(null);

        return historyEntry;
    }

    /**
     * Check if an array already contains a matching HistoryEntry.
     *
     * @param {HistoryEntry[]} array Array to search in
     * @param {string} uri URI to search for
     * @returns {boolean} Whether the array contains an item with $uri
     */
    _includesWallpaper(array, uri) {
        for (const element of array) {
            if (element.source.imageDownloadUrl === uri)
                return true;
        }

        return false;
    }

    /**
     * Check if this image is in the list of blocked images.
     *
     * @param {string} filename Name of the image
     * @returns {boolean} Whether the image is blocked
     */
    _isImageBlocked(filename) {
        const blockedFilenames = this._generalSettings.getStrv('blocked-images');

        if (blockedFilenames.includes(filename)) {
            Logger.info(`Image is blocked: ${filename}`, this);

            return true;
        }

        return false;
    }
}

export {BaseAdapter};
