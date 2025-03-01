import * as Utils from '../utils.js';
import {WallpaperManager} from './wallpaperManager.js';
import {Logger} from '../logger.js';
import {Settings} from '../settings.js';

/**
 * A general default wallpaper manager.
 *
 * Unable to handle multiple displays.
 */
class DefaultWallpaperManager extends WallpaperManager {
    /**
     * Sets the background image in light and dark mode.
     *
     * @param {string[]} wallpaperPaths Array of strings to image files, expects a single image only.
     * @returns {Promise<void>} Only resolves
     */
    async _setBackground(wallpaperPaths) {
        // The default manager can't handle multiple displays
        if (wallpaperPaths.length > 1)
            Logger.warn('Single handling manager called with multiple images!', this);

        await DefaultWallpaperManager.setSingleBackground(`file://${wallpaperPaths[0]}`, this._backgroundSettings);

        return Promise.resolve();
    }

    /**
     * Sets the lock screen image in light and dark mode.
     *
     * @param {string[]} wallpaperPaths Array of strings to image files, expects a single image only.
     * @returns {Promise<void>} Only resolves
     */
    async _setLockScreen(wallpaperPaths) {
        // The default manager can't handle multiple displays
        if (wallpaperPaths.length > 1)
            Logger.warn('Single handling manager called with multiple images!', this);

        await DefaultWallpaperManager.setSingleLockScreen(`file://${wallpaperPaths[0]}`, this._backgroundSettings, this._screensaverSettings);

        return Promise.resolve();
    }

    /**
     * Default fallback function to set a single image background.
     *
     * @param {string} wallpaperURI URI to image file
     * @param {Settings} backgroundSettings Settings containing the background `picture-uri` key
     * @returns {Promise<void>} Only resolves
     */
    static setSingleBackground(wallpaperURI, backgroundSettings) {
        const storedScalingMode = new Settings().getString('scaling-mode');

        if (Utils.isImageMerged(wallpaperURI))

            // merged wallpapers need mode "spanned"
            backgroundSettings.setString('picture-options', 'spanned');
        else if (storedScalingMode)
            backgroundSettings.setString('picture-options', storedScalingMode);

        Utils.setPictureUriOfSettingsObject(backgroundSettings, wallpaperURI);

        return Promise.resolve();
    }

    /**
     *Default fallback function to set a single image lock screen.
     *
     * @param {string} wallpaperURI URI to image file
     * @param {Settings} backgroundSettings Settings containing the background `picture-uri` key
     * @param {Settings} screensaverSettings Settings containing the lock screen `picture-uri` key
     * @returns {Promise<void>} Only resolves
     */
    static setSingleLockScreen(wallpaperURI, backgroundSettings, screensaverSettings) {
        const storedScalingMode = new Settings().getString('scaling-mode');

        if (Utils.isImageMerged(wallpaperURI))

            // merged wallpapers need mode "spanned"
            screensaverSettings.setString('picture-options', 'spanned');
        else if (storedScalingMode)
            screensaverSettings.setString('picture-options', storedScalingMode);

        Utils.setPictureUriOfSettingsObject(screensaverSettings, wallpaperURI);

        return Promise.resolve();
    }

    /**
     * Check if a filename matches a merged wallpaper name.
     *
     * Merged wallpaper need special handling as these are single images
     * but span across all displays.
     *
     * @param {string} _filename Unused naming to check
     * @returns {boolean} Whether the image is a merged wallpaper
     */
    static isImageMerged(_filename) {
        // This manager can't create merged wallpaper
        return false;
    }
}

export {DefaultWallpaperManager};
