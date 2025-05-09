import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import * as Utils from '../utils.js';
import {DefaultWallpaperManager} from './defaultWallpaperManager.js';
import {Mode, WallpaperManager} from './wallpaperManager.js';
import {Logger} from '../logger.js';

/**
 * Abstract base class for external manager to implement.
 */
class ExternalWallpaperManager extends WallpaperManager {
    constructor() {
        super(...arguments);
        this.canHandleMultipleImages = true;
        this._cancellable = null;
    }

    /**
     * Checks if the current manager is available in the `$PATH`.
     *
     * @returns {boolean} Whether the manager is found
     */
    isAvailable() {
        if (ExternalWallpaperManager._command !== null)
            return true;

        for (const command of this._possibleCommands) {
            const path = GLib.find_program_in_path(command);

            if (path) {
                ExternalWallpaperManager._command = [path];
                break;
            }
        }

        return ExternalWallpaperManager._command !== null;
    }

    /**
     * Set the wallpapers for a given mode.
     *
     * @param {string[]} wallpaperPaths Array of paths to the desired wallpapers, should match the display count
     * @param {Mode} mode Enum indicating what images to change
     */
    async setWallpaper(wallpaperPaths, mode = Mode.BACKGROUND) {
        if (wallpaperPaths.length < 1)
            throw new Error('Empty wallpaper array');


        // Cancel already running processes before setting new images
        this._cancelRunning();


        // Fallback to default manager, all currently supported external manager don't support setting single images
        if (wallpaperPaths.length === 1 || (mode === Mode.BACKGROUND_AND_LOCKSCREEN_INDEPENDENT && wallpaperPaths.length === 2)) {
            const promises = [];

            if (mode === Mode.BACKGROUND || mode === Mode.BACKGROUND_AND_LOCKSCREEN)
                promises.push(DefaultWallpaperManager.setSingleBackground(`file://${wallpaperPaths[0]}`, this._backgroundSettings));

            if (mode === Mode.LOCKSCREEN || mode === Mode.BACKGROUND_AND_LOCKSCREEN)
                promises.push(DefaultWallpaperManager.setSingleLockScreen(`file://${wallpaperPaths[0]}`, this._backgroundSettings, this._screensaverSettings));

            if (mode === Mode.BACKGROUND_AND_LOCKSCREEN_INDEPENDENT) {
                if (wallpaperPaths.length < 2)
                    throw new Error('Not enough wallpaper');


                // Half the images for the background
                promises.push(DefaultWallpaperManager.setSingleBackground(`file://${wallpaperPaths[0]}`, this._backgroundSettings));

                // Half the images for the lock screen
                promises.push(DefaultWallpaperManager.setSingleLockScreen(`file://${wallpaperPaths[1]}`, this._backgroundSettings, this._screensaverSettings));
            }

            await Promise.allSettled(promises);

            return;
        }


        /**
         * Don't run these concurrently!
         * External manager may need to shove settings around to circumvent the fact the manager writes multiple settings on its own.
         * These are called in this fixed order so external manager can rely on functions ran previously.
         */
        if (mode === Mode.BACKGROUND || mode === Mode.BACKGROUND_AND_LOCKSCREEN)
            await this._setBackground(wallpaperPaths);

        if (mode === Mode.LOCKSCREEN)
            await this._setLockScreen(wallpaperPaths);

        if (mode === Mode.BACKGROUND_AND_LOCKSCREEN)
            await this._setLockScreenAfterBackground(wallpaperPaths);

        if (mode === Mode.BACKGROUND_AND_LOCKSCREEN_INDEPENDENT) {
            await this._setBackground(wallpaperPaths.slice(0, wallpaperPaths.length / 2));
            await this._setLockScreen(wallpaperPaths.slice(wallpaperPaths.length / 2));
        }
    }

    /**
     * Forcefully stop a previously started manager process.
     */
    _cancelRunning() {
        if (this._cancellable === null)
            return;

        Logger.debug('Stopping manager process.', this);
        this._cancellable.cancel();
        this._cancellable = null;
    }

    /**
     * Wrapper around calling the program command together with arguments.
     *
     * @param {string[]} commandArguments Arguments to append
     */
    async _runExternal(commandArguments) {
        // Cancel already running processes before starting new ones
        this._cancelRunning();

        if (!ExternalWallpaperManager._command || ExternalWallpaperManager._command.length < 1)
            throw new Error('Command empty!');


        // Needs a copy here
        const command = ExternalWallpaperManager._command.concat(commandArguments);
        this._cancellable = new Gio.Cancellable();
        Logger.debug(`Running command: ${command.toString()}`, this);
        await Utils.execCheck(command, this._cancellable);
        this._cancellable = null;
    }

    /**
     * Sync the lock screen to the background.
     *
     * This function exists to save compute time on identical background and lock screen images.
     *
     * @param {string[]} _wallpaperPaths Unused array of strings to image files
     * @returns {Promise<void>} Only resolves
     */
    _setLockScreenAfterBackground(_wallpaperPaths) {
        Utils.setPictureUriOfSettingsObject(this._screensaverSettings, this._backgroundSettings.getString('picture-uri'));

        return Promise.resolve();
    }
}
ExternalWallpaperManager._command = null;
export {ExternalWallpaperManager};
