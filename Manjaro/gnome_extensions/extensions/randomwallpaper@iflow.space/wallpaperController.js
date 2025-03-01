import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as HistoryModule from './history.js';
import * as SettingsModule from './settings.js';
import * as Utils from './utils.js';
import * as Settings from './settings.js';
import {AFTimer as Timer} from './timer.js';
import {Logger} from './logger.js';
import {Mode} from './manager/wallpaperManager.js';
import {Notification} from './notifications.js';
import {GenericJsonAdapter} from './adapter/genericJson.js';
import {LocalFolderAdapter} from './adapter/localFolder.js';
import {RedditAdapter} from './adapter/reddit.js';
import {UnsplashAdapter} from './adapter/unsplash.js';
import {UrlSourceAdapter} from './adapter/urlSource.js';
import {WallhavenAdapter} from './adapter/wallhaven.js';

// https://gjs.guide/guides/gjs/asynchronous-programming.html#promisify-helper
Gio._promisify(Gio.File.prototype, 'move_async', 'move_finish');

/**
 * The main wallpaper handler.
 */
class WallpaperController {
    /**
     * Create a new controller.
     *
     * Should only exists once to avoid weird shenanigans because the extension background
     * and preferences page existing in two different contexts.
     */
    constructor() {
        this._backendConnection = new SettingsModule.Settings(SettingsModule.RWG_SETTINGS_SCHEMA_BACKEND_CONNECTION);
        this._settings = new SettingsModule.Settings();
        this._timer = Timer.getTimer();
        this._wallpaperManager = Utils.getWallpaperManager();
        this._autoFetch = {active: false, duration: 30};

        /** functions will be called upon loading a new wallpaper */
        this._startLoadingHooks = [];

        /** functions will be called when loading a new wallpaper stopped. */
        this._stopLoadingHooks = [];
        this._observedValues = [];
        this._observedBackgroundValues = [];
        this.savedBackgroundURI = null;
        let xdg_cache_home = GLib.getenv('XDG_CACHE_HOME');

        if (!xdg_cache_home) {
            const home = GLib.getenv('HOME');

            if (home)
                xdg_cache_home = `${home}/.cache`;
            else
                xdg_cache_home = '/tmp';
        }

        const extensionObject = Extension.lookupByURL(import.meta.url);

        if (!extensionObject) {
            Logger.error('Own extension object not found!', this);
            throw new Error('Own extension object not found!');
        }

        this.wallpaperLocation = `${xdg_cache_home}/${extensionObject.metadata['uuid']}/wallpapers/`;
        const mode = 0o0755;
        GLib.mkdir_with_parents(this.wallpaperLocation, mode);
        this._historyController = new HistoryModule.HistoryController(this.wallpaperLocation);

        // Bring values to defined state
        this._backendConnection.setBoolean('clear-history', false);
        this._backendConnection.setBoolean('open-folder', false);
        this._backendConnection.setBoolean('pause-timer', false);
        this._backendConnection.setBoolean('request-new-wallpaper', false);
        this._backendConnection.setBoolean('backend-connection-available', true);

        // Track value changes
        this._observedBackgroundValues.push(this._backendConnection.observe('clear-history', () => this._clearHistory()));
        this._observedBackgroundValues.push(this._backendConnection.observe('open-folder', () => this._openFolder()));
        this._observedBackgroundValues.push(this._backendConnection.observe('pause-timer', () => this._pauseTimer()));
        this._observedBackgroundValues.push(this._backendConnection.observe('request-new-wallpaper', () => this._requestNewWallpaper().catch(error => {
            Logger.error(error, this);
        })));
        this._observedValues.push(this._settings.observe('history-length', () => this._updateHistory()));
        this._observedValues.push(this._settings.observe('auto-fetch', () => this._updateAutoFetching()));
        this._observedValues.push(this._settings.observe('minutes', () => this._updateAutoFetching()));
        this._observedValues.push(this._settings.observe('hours', () => this._updateAutoFetching()));

        /**
         * When the user installs a manager we won't notice that it's available.
         * The preference window however checks on startup for availability and will allow this setting
         * to change. Let's listen for that change and update our manager accordingly.
         */
        this._observedValues.push(this._settings.observe('multiple-displays', () => this._updateWallpaperManager()));
        this._updateHistory();

        // Fetching and merging wallpaper can be quite heavy on load so try doing this only when idle
        GLib.idle_add(GLib.PRIORITY_DEFAULT_IDLE, () => {
            // This may start the timer which might load a new wallpaper on interval surpassed
            this._updateAutoFetching();


            // load a new wallpaper on startup, but don't when the timer already fetched one because of a surpassed timer interval
            if (this._settings.getBoolean('fetch-on-startup') && (!this._timer.isEnabled() || this._timer.minutesElapsed() > 1)) {
                this.fetchNewWallpaper().catch(error => {
                    Logger.error(error, this);
                });
            }

            return GLib.SOURCE_REMOVE;
        });

        // Initialize favorites folder
        // TODO: There's probably a better place for this
        const favoritesFolderSetting = this._settings.getString('favorites-folder');

        let favoritesFolder;

        if (favoritesFolderSetting === '') {
            const directoryPictures = GLib.get_user_special_dir(GLib.UserDirectory.DIRECTORY_PICTURES);

            if (directoryPictures === null) {
                // Pictures not set up
                const directoryDownloads = GLib.get_user_special_dir(GLib.UserDirectory.DIRECTORY_DOWNLOAD);

                if (directoryDownloads === null) {
                    const xdg_data_home = GLib.get_user_data_dir();
                    favoritesFolder = Gio.File.new_for_path(xdg_data_home);
                } else {
                    favoritesFolder = Gio.File.new_for_path(directoryDownloads);
                }
            } else {
                favoritesFolder = Gio.File.new_for_path(directoryPictures);
            }

            favoritesFolder = favoritesFolder.get_child(extensionObject.metadata['uuid']);
            const favoritesFolderPath = favoritesFolder.get_path();

            if (favoritesFolderPath)
                this._settings.setString('favorites-folder', favoritesFolderPath);
        }
    }

    /**
     * Clean up extension remnants.
     */
    cleanup() {
        this._backendConnection.setBoolean('backend-connection-available', false);

        for (const observedValue of this._observedValues)
            this._settings.disconnect(observedValue);

        this._observedValues = [];

        for (const observedValue of this._observedBackgroundValues)
            this._backendConnection.disconnect(observedValue);

        this._observedBackgroundValues = [];
    }

    /**
     * Empty the history. (Background settings observer edition)
     */
    _clearHistory() {
        if (this._backendConnection.getBoolean('clear-history')) {
            this.update();
            this.deleteHistory();
            this._backendConnection.setBoolean('clear-history', false);
        }
    }

    /**
     * Open the internal wallpaper cache folder. (Background settings observer edition)
     */
    _openFolder() {
        if (this._backendConnection.getBoolean('open-folder')) {
            const uri = GLib.filename_to_uri(this.wallpaperLocation, '');
            Gio.AppInfo.launch_default_for_uri(uri, Gio.AppLaunchContext.new());
            this._backendConnection.setBoolean('open-folder', false);
        }
    }

    /**
     * Pause or resume the timer. (Background settings observer edition)
     */
    _pauseTimer() {
        if (this._backendConnection.getBoolean('pause-timer'))
            this._timer.pause();
        else
            this._timer.continue();
    }

    /**
     * Get a fresh wallpaper. (Background settings observer edition)
     */
    async _requestNewWallpaper() {
        if (this._backendConnection.getBoolean('request-new-wallpaper')) {
            this.update();

            try {
                await this.fetchNewWallpaper();
            } finally {
                this.update();
                this._backendConnection.setBoolean('request-new-wallpaper', false);
            }
        }
    }

    /**
     * Update the history.
     *
     * Loads from settings.
     */
    _updateHistory() {
        this._historyController.load();
    }

    /**
     * Update settings related to the auto fetching.
     */
    _updateAutoFetching() {
        let duration = 0;
        duration += this._settings.getInt('minutes');
        duration += this._settings.getInt('hours') * 60;
        this._autoFetch.duration = duration;
        this._autoFetch.active = this._settings.getBoolean('auto-fetch');

        if (this._autoFetch.active) {
            this._timer.registerCallback(() => {
                return this.fetchNewWallpaper();
            });
            this._timer.setMinutes(this._autoFetch.duration);
            this._timer.start().catch(error => {
                Logger.error(error, this);
            });
        } else {
            this._timer.stop();
        }
    }

    /**
     * Update the wallpaper manager on settings change.
     */
    _updateWallpaperManager() {
        this._wallpaperManager = Utils.getWallpaperManager();
    }

    /**
     * Get an array of random adapter needed to fill the display $count.
     *
     * A single adapter can be assigned for multiple images so you may get less than $count adapter back.
     *
     * Returns a default UnsplashAdapter in case of failure.
     *
     * @param {number} count The amount of wallpaper requested
     * @returns {RandomAdapterResult[]} Array of info objects how many images are needed for each adapter
     */
    _getRandomAdapter(count) {
        const sourceIDs = this._getRandomSource(count);
        const randomAdapterResult = [];

        if (sourceIDs.length < 1 || sourceIDs[0] === '-1') {
            randomAdapterResult.push({
                adapter: new UnsplashAdapter(null, null),
                id: '-1',
                type: 0,
                imageCount: count,
            });

            return randomAdapterResult;
        }


        /**
         * Check if we've chosen the same adapter type before.
         *
         * @param {RandomAdapterResult[]} array Array of already chosen adapter
         * @param {number} type Type of the source
         * @returns {RandomAdapterResult | null} Found adapter or null
         */
        function _arrayIncludes(array, type) {
            for (const element of array) {
                if (element.type === type)
                    return element;
            }

            return null;
        }

        for (let index = 0; index < sourceIDs.length; index++) {
            const sourceID = sourceIDs[index];
            const path = `${SettingsModule.RWG_SETTINGS_SCHEMA_PATH}/sources/general/${sourceID}/`;
            const settingsGeneral = new SettingsModule.Settings(SettingsModule.RWG_SETTINGS_SCHEMA_SOURCES_GENERAL, path);

            let imageSourceAdapter;
            let sourceName = 'undefined';
            let sourceType = -1;
            sourceName = settingsGeneral.getString('name');
            sourceType = settingsGeneral.getInt('type');
            const availableAdapter = _arrayIncludes(randomAdapterResult, sourceType);

            if (availableAdapter) {
                availableAdapter.imageCount++;
                continue;
            }

            try {
                switch (sourceType) {
                case Utils.SourceType.UNSPLASH:
                    imageSourceAdapter = new UnsplashAdapter(sourceID, sourceName);
                    break;
                case Utils.SourceType.WALLHAVEN:
                    imageSourceAdapter = new WallhavenAdapter(sourceID, sourceName);
                    break;
                case Utils.SourceType.REDDIT:
                    imageSourceAdapter = new RedditAdapter(sourceID, sourceName);
                    break;
                case Utils.SourceType.GENERIC_JSON:
                    imageSourceAdapter = new GenericJsonAdapter(sourceID, sourceName);
                    break;
                case Utils.SourceType.LOCAL_FOLDER:
                    imageSourceAdapter = new LocalFolderAdapter(sourceID, sourceName);
                    break;
                case Utils.SourceType.STATIC_URL:
                    imageSourceAdapter = new UrlSourceAdapter(sourceID, sourceName);
                    break;
                default:
                    imageSourceAdapter = new UnsplashAdapter(null, null);
                    sourceType = 0;
                    break;
                }
            } catch (error) {
                Logger.warn('Had errors, fetching with default settings.', this);
                imageSourceAdapter = new UnsplashAdapter(null, null);
                sourceType = Utils.SourceType.UNSPLASH;
            }

            randomAdapterResult.push({
                adapter: imageSourceAdapter,
                id: sourceID,
                type: sourceType,
                imageCount: 1,
            });
        }

        return randomAdapterResult;
    }

    /**
     * Gets randomly $count amount of enabled sources.
     *
     * The same source can appear multiple times in the resulting array.
     *
     * @param {number} count Amount of requested source IDs
     * @returns {string[]} Array of source IDs or ['-1'] in case of failure
     */
    _getRandomSource(count) {
        const sourceResult = [];
        const sources = this._settings.getStrv('sources');

        if (sources === null || sources.length < 1)
            return ['-1'];

        const enabledSources = sources.filter(element => {
            const path = `${SettingsModule.RWG_SETTINGS_SCHEMA_PATH}/sources/general/${element}/`;
            const settingsGeneral = new SettingsModule.Settings(SettingsModule.RWG_SETTINGS_SCHEMA_SOURCES_GENERAL, path);

            return settingsGeneral.getBoolean('enabled');
        });

        if (enabledSources === null || enabledSources.length < 1)
            return ['-1'];

        for (let index = 0; index < count; index++) {
            const chosenSource = enabledSources[Utils.getRandomNumber(enabledSources.length)];
            sourceResult.push(chosenSource);
        }

        return sourceResult;
    }

    /**
     * Run a configured post command.
     */
    _runPostCommands() {
        const backgroundSettings = new SettingsModule.Settings('org.gnome.desktop.background');
        const commandString = this._settings.getString('general-post-command');

        // Read the current wallpaper uri from settings because it could be a merged wallpaper
        // Remove prefix "file://" to get the real path
        const currentWallpaperPath = backgroundSettings.getString('picture-uri').replace(/^file:\/\//, '');

        // TODO: this ignores the lock-screen
        const generalPostCommandArray = this._getCommandArray(commandString, currentWallpaperPath);

        if (generalPostCommandArray !== null) {
            // Do not await this call, let it be one shot
            Utils.execCheck(generalPostCommandArray).catch(error => {
                Logger.error(error, this);
            });
        }
    }

    /**
     * Fill an array with images from the history until $count.
     *
     * @param {string[]} wallpaperArray Array of wallpaper paths
     * @param {number | undefined} requestCount Amount of wallpaper paths $wallpaperArray should contain, defaults to the value reported by _getCurrentDisplayCount()
     * @returns {string[]} Array of wallpaper paths matching the length of $count
     */
    _fillDisplaysFromHistory(wallpaperArray, requestCount) {
        const count = requestCount ?? this._getCurrentDisplayCount();
        const newWallpaperArray = [...wallpaperArray];


        // Abuse history to fill missing images
        for (let index = newWallpaperArray.length; index < count; index++) {
            let historyElement;

            do
                historyElement = this._historyController.getRandom();
            while (this._historyController.history.length > count && historyElement.path && newWallpaperArray.includes(historyElement.path));


            // try to ensure different wallpaper for all displays if possible
            if (historyElement.path)
                newWallpaperArray.push(historyElement.path);
        }


        // Trim array if we have too many images, possibly by having a too long input array
        return newWallpaperArray.slice(0, count);
    }

    /**
     * Set an existing history entry as wallpaper.
     *
     * @param {HistoryModule.HistoryEntry} historyEntry The history entry to set as wallpaper.
     */
    async setWallpaper(historyEntry) {
        const changeType = this._settings.getInt('change-type');
        const usedWallpaperPaths = this._fillDisplaysFromHistory([historyEntry.path]);


        // ignore changeType === Mode.BACKGROUND_AND_LOCKSCREEN_INDEPENDENT because that doesn't make sense
        // when requesting a specific history entry
        if (changeType > Mode.BACKGROUND_AND_LOCKSCREEN)
            await this._wallpaperManager.setWallpaper(usedWallpaperPaths, Mode.BACKGROUND_AND_LOCKSCREEN);
        else
            await this._wallpaperManager.setWallpaper(usedWallpaperPaths, changeType);


        // Saved the new background when it was changed (i.e., when the mode isn't lock-screen only) and
        // when it is required for resetting to the correct state.
        if (this.savedBackgroundURI && changeType !== Mode.LOCKSCREEN)
            this.rememberCurrentWallpaper();

        this._runPostCommands();
        usedWallpaperPaths.reverse().forEach(path => {
            const id = this._historyController.getEntryByPath(path)?.id;

            if (id)
                this._historyController.promoteToActive(id);
        });
    }

    /**
     * Fetch fresh wallpaper.
     */
    async fetchNewWallpaper() {
        this._startLoadingHooks.forEach(element => element());

        try {
            const changeType = this._settings.getInt('change-type');

            let monitorCount = this._getCurrentDisplayCount();


            // Request double the amount of displays if we need background and lock screen
            if (changeType === Mode.BACKGROUND_AND_LOCKSCREEN_INDEPENDENT)
                monitorCount *= 2;

            const imageAdapters = this._getRandomAdapter(monitorCount);
            const randomImagePromises = imageAdapters.map(element => {
                return element.adapter.requestRandomImage(element.imageCount);
            });
            const newWallpapers = await Promise.allSettled(randomImagePromises);
            const fetchPromises = newWallpapers.flatMap((object, index) => {
                const fetchPromiseArray = [];

                let array = [];


                // rejected promises
                if ('reason' in object && Array.isArray(object.reason) && object.reason.length > 0 && object.reason[0] instanceof HistoryModule.HistoryEntry)
                    array = object.reason;


                // fulfilled promises
                if ('value' in object)
                    array = object.value;

                for (const element of array) {
                    element.adapter = {
                        id: imageAdapters[index].id,
                        type: imageAdapters[index].type,
                    };
                    Logger.debug(`Requesting image: ${element.source.imageDownloadUrl}`, this);
                    fetchPromiseArray.push(imageAdapters[index].adapter.fetchFile(element));
                }

                return fetchPromiseArray;
            });

            if (fetchPromises.length < 1)
                throw new Error('Unable to request new images.');


            // wait for all fetching images
            Logger.info(`Requesteing ${fetchPromises.length} new images.`, this);
            const newImageEntriesPromiseResults = await Promise.allSettled(fetchPromises);
            const newImageEntries = newImageEntriesPromiseResults.map(element => {
                if (element.status !== 'fulfilled' && !('value' in element))
                    return null;

                return element.value;
            }).filter(element => {
                return element instanceof HistoryModule.HistoryEntry;
            });
            Logger.debug(`Fetched ${newImageEntries.length} new images.`, this);
            const newWallpaperPaths = newImageEntries.map(element => {
                return element.path;
            });

            if (newWallpaperPaths.length < 1)
                throw new Error('Unable to fetch new images.');

            if (newWallpaperPaths.length < monitorCount)
                Logger.warn('Unable to fill all displays with new images.', this);

            const usedWallpaperPaths = this._fillDisplaysFromHistory(newWallpaperPaths, monitorCount);
            await this._wallpaperManager.setWallpaper(usedWallpaperPaths, changeType);


            // Saved the new background when it was changed (i.e., when the mode isn't lock-screen only) and
            // when it is required for resetting to the correct state.
            if (this.savedBackgroundURI && changeType !== Mode.LOCKSCREEN)
                this.rememberCurrentWallpaper();

            usedWallpaperPaths.reverse().forEach(path => {
                const id = this._historyController.getEntryByPath(path)?.id;

                if (id)
                    this._historyController.promoteToActive(id);
            });

            // insert new wallpapers into history
            this._historyController.insert(newImageEntries.reverse());
            this._runPostCommands();

            if (this._settings.getBoolean('show-notifications'))
                Notification.newWallpaper(newImageEntries.reverse());
        } catch (error) {
            Logger.error(error, this);

            if (this._settings.getBoolean('show-notifications'))
                Notification.fetchWallpaperFailed(error);
        } finally {
            this._stopLoadingHooks.forEach(element => element());
        }
    }

    // TODO: Change to original historyElement if more variable get exposed
    /**
     * Get a command array from a string.
     *
     * Fills variables if found:
     * - %wallpaper_path%
     *
     * @param {string} commandString String to parse an array from
     * @param {string} historyElementPath Wallpaper path to fill into the variable
     * @returns {string[] | null} Command array or null
     */
    _getCommandArray(commandString, historyElementPath) {
        let string = commandString;

        if (string === '')
            return null;


        // Replace variables
        const variables = new Map();
        variables.set('%wallpaper_path%', historyElementPath);
        variables.forEach((value, key) => {
            string = string.replaceAll(key, value);
        });

        try {
            // https://gjs-docs.gnome.org/glib20/glib.shell_parse_argv
            // Parses a command line into an argument vector, in much the same way
            // the shell would, but without many of the expansions the shell would
            // perform (variable expansion, globs, operators, filename expansion,
            // etc. are not supported).
            return GLib.shell_parse_argv(string)[1];
        } catch (e) {
            Logger.warn(String(e), this);
        }

        return null;
    }

    /**
     * Get the current number of displays.
     *
     * This also takes the user setting and wallpaper manager availability into account
     * and lies accordingly by reporting only 1 display.
     *
     * @returns {number} Amount of currently activated displays or 1
     */
    _getCurrentDisplayCount() {
        if (!this._settings.getBoolean('multiple-displays'))
            return 1;

        if (!this._wallpaperManager.canHandleMultipleImages)
            return 1;

        return Utils.getMonitorCount();
    }

    /**
     * Preview an image in the history.
     *
     * @param {string} historyId Unique ID
     */
    previewWallpaper(historyId) {
        // only store the background if it wasn't stored yet
        if (!this.savedBackgroundURI) {
            // Saved the current background so we can revert to it when the reset function is called
            this.rememberCurrentWallpaper();
        }

        if (!this._settings.getBoolean('disable-hover-preview')) {
            this._previewId = historyId;

            // Do not fill other displays here.
            // Merging images can take a long time and hurt the quick preview purpose.
            // Therefor only an array with a single wallpaper path here:
            const newWallpaperPaths = [this.wallpaperLocation + this._previewId];
            this._wallpaperManager.setWallpaper(newWallpaperPaths).catch(error => {
                Logger.error(error, this);
            });
        }
    }

    /**
     * Reset the wallpaper to the last known URI.
     */
    resetPreview() {
        if (!this._settings.getBoolean('disable-hover-preview') && this.savedBackgroundURI) {
            Logger.debug(`Resetting desktop preview to: ${this.savedBackgroundURI}`, this);
            this._wallpaperManager.setWallpaper([GLib.filename_from_uri(this.savedBackgroundURI)[0]]).catch(error => {
                Logger.error(error, this);
            });
        }

        this.savedBackgroundURI = null;
    }

    /**
     * Store the current wallpaper that will be used to reset the preview.
     */
    rememberCurrentWallpaper() {
        // Update saved background with newly set background image
        // so we don't revert to an older state when closing the menu
        const backgroundSettings = new Settings.Settings('org.gnome.desktop.background');
        this.savedBackgroundURI = backgroundSettings.getString('picture-uri');
        Logger.debug(`Saved current background for reset: ${this.savedBackgroundURI}`, this);
    }

    /**
     * Get the HistoryController.
     *
     * @returns {HistoryModule.HistoryController} The history controller
     */
    getHistoryController() {
        return this._historyController;
    }

    /**
     * Empty the history.
     */
    deleteHistory() {
        this._historyController.clear();
    }

    /**
     * Update the history.
     */
    update() {
        this._updateHistory();
    }

    /**
     * Register a function which gets called on wallpaper fetching.
     *
     * Can take multiple hooks.
     *
     * @param {() => void} fn Function to call
     */
    registerStartLoadingHook(fn) {
        if (typeof fn === 'function')
            this._startLoadingHooks.push(fn);
    }

    /**
     * Register a function which gets called when done wallpaper fetching.
     *
     * Can take multiple hooks.
     *
     * @param {() => void} fn Function to call
     */
    registerStopLoadingHook(fn) {
        if (typeof fn === 'function')
            this._stopLoadingHooks.push(fn);
    }
}

export {WallpaperController};
