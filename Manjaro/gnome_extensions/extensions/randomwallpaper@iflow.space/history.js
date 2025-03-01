import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import * as Utils from './utils.js';
import {Logger} from './logger.js';
import {Settings} from './settings.js';


// Gets filled by the HistoryController which is constructed at extension startup
let _wallpaperLocation;

/**
 * Defines an image with core properties.
 */
class HistoryEntry {
    /**
     * Create a new HistoryEntry.
     *
     * The name, id, and path will be prefilled.
     *
     * @param {string | null} author Author of the image or null
     * @param {string | null} source The image source or null
     * @param {string} url The request URL of the image
     */
    constructor(author, source, url) {
        this.timestamp = new Date().getTime();
        this.adapter = {
            id: null,
            type: null,
        };
        this.source = {
            author,
            authorUrl: null,
            source,
            sourceUrl: null,
            imageDownloadUrl: url,
            imageLinkUrl: url, // URL used for linking back to the website of the image
        };

        // extract the name from the url
        this.name = Utils.fileName(this.source.imageDownloadUrl);
        this.id = `${this.timestamp}_${this.name}`;
        this.path = `${_wallpaperLocation}/${this.id}`;
    }
}

/**
 * Controls the history and related code parts.
 */
class HistoryController {
    /**
     * Create a new HistoryController.
     *
     * Loads an existing history from the settings schema.
     *
     * @param {string} wallpaperLocation Root save location for new HistoryEntries.
     */
    constructor(wallpaperLocation) {
        this.history = [];
        this.size = 10;
        this._settings = new Settings();
        _wallpaperLocation = wallpaperLocation;
        this.load();
    }

    /**
     * Insert images at the beginning of the history.
     *
     * Throws old images out of the stack and saves to the schema.
     *
     * @param {HistoryEntry[]} historyElements Array of elements to insert
     */
    insert(historyElements) {
        for (const historyElement of historyElements)
            this.history.unshift(historyElement);

        this._deleteOldPictures();
        this.save();
    }

    /**
     * Set the given id to to the first history element (the current one)
     *
     * @param {string} id ID of the historyEntry
     * @returns {boolean} Whether the sorting was successful
     */
    promoteToActive(id) {
        const element = this.get(id);

        if (element === null)
            return false;

        element.timestamp = new Date().getTime();
        this.history = this.history.sort((elem1, elem2) => {
            return elem1.timestamp < elem2.timestamp ? 1 : 0;
        });
        this.save();

        return true;
    }

    /**
     * Get a specific HistoryEntry by ID.
     *
     * @param {string} id ID of the HistoryEntry
     * @returns {HistoryEntry | null} The corresponding HistoryEntry or null
     */
    get(id) {
        for (const elem of this.history) {
            if (elem.id === id)
                return elem;
        }

        return null;
    }

    /**
     * Get the current history element.
     *
     * @returns {HistoryEntry} Current first entry
     */
    getCurrentEntry() {
        return this.history[0];
    }

    /**
     * Get a HistoryEntry by its file path.
     *
     * @param {string} path Path to search for
     * @returns {HistoryEntry | null} The corresponding HistoryEntry or null
     */
    getEntryByPath(path) {
        for (const element of this.history) {
            if (element.path === path)
                return element;
        }

        return null;
    }

    /**
     * Get a random HistoryEntry.
     *
     * @returns {HistoryEntry} Random entry
     */
    getRandom() {
        return this.history[Utils.getRandomNumber(this.history.length)];
    }

    /**
     * Load the history from the schema
     */
    load() {
        this.size = this._settings.getInt('history-length');
        const stringHistory = this._settings.getStrv('history');
        this.history = stringHistory.map(elem => {
            const unknownObject = JSON.parse(elem);

            if (!this._isHistoryEntry(unknownObject))
                throw new Error('Failed loading history data.');

            return unknownObject;
        });
    }

    /**
     * Save the history to the schema
     */
    save() {
        const stringHistory = this.history.map(elem => {
            return JSON.stringify(elem);
        });
        this._settings.setStrv('history', stringHistory);
        Gio.Settings.sync();
    }

    /**
     * Clear the history and delete all photos except the current one.
     *
     * This function clears the cache folder, ignoring if the image appears in the history or not.
     */
    clear() {
        const firstHistoryElement = this.history[0];
        this.history = [];
        const directory = Gio.file_new_for_path(_wallpaperLocation);
        const enumerator = directory.enumerate_children('', Gio.FileQueryInfoFlags.NONE, null);

        let fileInfo;

        do {
            fileInfo = enumerator.next_file(null);

            if (!fileInfo)
                break;

            const id = fileInfo.get_name();


            // ignore hidden files and first element
            if (id[0] !== '.' && id !== firstHistoryElement.id) {
                const deleteFile = Gio.file_new_for_path(_wallpaperLocation + id);
                this._deleteFile(deleteFile);
            }
        } while (fileInfo);
        this.save();
    }

    /**
     * Delete all pictures that have no slot in the history.
     */
    _deleteOldPictures() {
        this.size = this._settings.getInt('history-length');

        while (this.history.length > this.size) {
            const path = this.history.pop()?.path;

            if (!path)
                continue;

            const file = Gio.file_new_for_path(path);
            this._deleteFile(file);
        }
    }

    /**
     * Helper function to delete files.
     *
     * Has some special treatments factored in to ignore file not found issues
     * when the parent path is available.
     *
     * @param {Gio.File} file The file to delete
     * @throws On any other error than Gio.IOErrorEnum.NOT_FOUND
     */
    _deleteFile(file) {
        try {
            file.delete(null);
        } catch (error) {
            /**
             * Ignore deletion errors when the file doesn't exist but the parent path is accessible.
             * This tries to avoid invalid states later on because we would have thrown here and therefore skip saving.
             */
            if (file.get_parent()?.query_exists(null) && error instanceof GLib.Error && error.matches(Gio.io_error_quark(), Gio.IOErrorEnum.NOT_FOUND)) {
                Logger.warn(`Ignoring Gio.IOErrorEnum.NOT_FOUND: ${file.get_path() ?? 'undefined'}`, this);

                return;
            }

            throw error;
        }
    }

    /**
     * Check if an object is a HistoryEntry.
     *
     * @param {unknown} object Object to check
     * @returns {boolean} Whether the object is a HistoryEntry
     */
    _isHistoryEntry(object) {
        if (typeof object === 'object' &&
            object &&
            'timestamp' in object &&
            typeof object.timestamp === 'number' &&
            'id' in object &&
            typeof object.id === 'string' &&
            'path' in object &&
            typeof object.path === 'string')
            return true;

        return false;
    }
}

export {HistoryEntry, HistoryController};
