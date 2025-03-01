import * as Utils from '../utils.js';
import {ExternalWallpaperManager} from './externalWallpaperManager.js';

/**
 * Wrapper for Superpaper using it as a manager.
 */
class Superpaper extends ExternalWallpaperManager {
    constructor() {
        super(...arguments);
        this._possibleCommands = ['superpaper'];
    }

    /**
     * Sets the background image in light and dark mode.
     *
     * @param {string[]} wallpaperPaths Array of strings to image files
     */
    // We don't need the settings object because Superpaper already set both picture-uri on it's own.
    async _setBackground(wallpaperPaths) {
        await this._createCommandAndRun(wallpaperPaths);
    }

    /**
     * Sets the lock screen image in light and dark mode.
     *
     * @param {string[]} wallpaperPaths Array of strings to image files
     */
    async _setLockScreen(wallpaperPaths) {
        // Remember keys, Superpaper will change these
        const tmpBackground = this._backgroundSettings.getString('picture-uri');
        const tmpBackgroundDark = this._backgroundSettings.getString('picture-uri-dark');
        const tmpMode = this._backgroundSettings.getString('picture-options');
        await this._createCommandAndRun(wallpaperPaths);
        this._screensaverSettings.setString('picture-options', 'spanned');
        Utils.setPictureUriOfSettingsObject(this._screensaverSettings, this._backgroundSettings.getString('picture-uri-dark'));

        // Superpaper possibly changed these, change them back
        this._backgroundSettings.setString('picture-uri', tmpBackground);
        this._backgroundSettings.setString('picture-uri-dark', tmpBackgroundDark);
        this._backgroundSettings.setString('picture-options', tmpMode);
    }

    // https://github.com/hhannine/superpaper/blob/master/docs/cli-usage.md
    /**
     * Run Superpaper in CLI mode.
     *
     * Superpaper:
     * - Saves merged images alternating in `$XDG_CACHE_HOME/superpaper/temp/cli-{a,b}.png`
     * - Sets `picture-option` to `spanned`
     * - Always sets both `picture-uri` and `picture-uri-dark` options
     * - Can use only single images
     *
     * @param {string[]} wallpaperArray Array of paths to the desired wallpapers, should match the display count, can be a single image
     */
    async _createCommandAndRun(wallpaperArray) {
        let command = [];

        // cspell:disable-next-line
        command.push('--setimages');
        command = command.concat(wallpaperArray);
        await this._runExternal(command);
    }

    /**
     * Check if a filename matches a merged wallpaper name.
     *
     * Merged wallpaper need special handling as these are single images
     * but span across all displays.
     *
     * @param {string} filename Naming to check
     * @returns {boolean} Whether the image is a merged wallpaper
     */
    static isImageMerged(filename) {
        const mergedWallpaperNames = [
            'cli-a',
            'cli-b',
        ];

        for (const name of mergedWallpaperNames) {
            if (filename.includes(name))
                return true;
        }

        return false;
    }
}

export {Superpaper};
