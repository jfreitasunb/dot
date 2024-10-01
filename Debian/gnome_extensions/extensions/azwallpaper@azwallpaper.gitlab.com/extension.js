/* eslint-disable jsdoc/require-jsdoc */
const {GLib} = imports.gi;
const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const {
    main: Main,
    popupMenu: PopupMenu,
} = imports.ui;

const {BingWallpaperDownloader} = Me.imports.bingWallpaperDownloader;
const {Slideshow} = Me.imports.slideshow;
const {debugLog} = Me.imports.utils;

const Gettext = imports.gettext.domain(Me.metadata['gettext-domain']);
const _ = Gettext.gettext;

function init() {
    ExtensionUtils.initTranslations(Me.metadata['gettext-domain']);
    return new AzWallpaper();
}

class AzWallpaper {
    enable() {
        const settings = ExtensionUtils.getSettings();

        Me.settings = settings;

        this._slideShow = new Slideshow();
        this._bingWallpaperDownloader = new BingWallpaperDownloader();

        this._oldAddBackgroundMenu = Main.layoutManager._addBackgroundMenu;
        Main.layoutManager._addBackgroundMenu = bgManager => {
            this._oldAddBackgroundMenu.call(Main.layoutManager, bgManager);
            const menu = bgManager.backgroundActor._backgroundMenu;
            this._modifyBackgroundMenu(menu);
        };

        settings.connectObject('changed::slideshow-slide-duration', () => this._slideShow.startSlideshow(), this);
        settings.connectObject('changed::slideshow-directory', () => this._slideshowDirectoryChanged(), this);
        settings.connectObject('changed::bing-wallpaper-download', () => this._startBingWallpaperDownloader(), this);
        settings.connectObject('changed::bing-download-directory', () => this._startBingWallpaperDownloader(), this);

        this._delayStartId = GLib.timeout_add_seconds(GLib.PRIORITY_LOW, 1, () => {
            this._startBingWallpaperDownloader();
            this._slideShow.initiate();
            Main.layoutManager._updateBackgrounds();

            this._delayStartId = null;
            return GLib.SOURCE_REMOVE;
        });
    }

    disable() {
        debugLog('disabled()');

        if (this._delayStartId) {
            GLib.source_remove(this._delayStartId);
            this._delayStartId = null;
        }

        Main.layoutManager._addBackgroundMenu = this._oldAddBackgroundMenu;
        Main.layoutManager._updateBackgrounds();

        this._bingWallpaperDownloader.endDownloaderTimer();
        this._bingWallpaperDownloader = null;
        this._slideShow.destroy();
        this._slideShow = null;
        Me.settings.disconnectObject(this);
        Me.settings = null;
    }

    _slideshowDirectoryChanged() {
        this._slideShow.reset();
        this._slideShow.initiate();
    }

    _startBingWallpaperDownloader() {
        this._bingWallpaperDownloader.endDownloaderTimer();
        if (Me.settings.get_boolean('bing-wallpaper-download'))
            this._bingWallpaperDownloader.initiate();
    }

    _modifyBackgroundMenu(menu) {
        menu.removeAll();
        menu._settingsActions = {};

        let menuItem = new PopupMenu.PopupMenuItem(_('Next Wallpaper'));
        menuItem.connect('activate', () => {
            debugLog('\'Next Wallpaper\' clicked.');
            this._slideShow.startSlideshow(0, true);
        });
        menu.addMenuItem(menuItem);

        menuItem = new PopupMenu.PopupMenuItem(_('Slideshow Settings'));
        menuItem.connect('activate', () => ExtensionUtils.openPrefs());
        menu.addMenuItem(menuItem);

        menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());

        menu.addSettingsAction(_('Display Settings'), 'gnome-display-panel.desktop');
        menu.addSettingsAction(_('Settings'), 'org.gnome.Settings.desktop');
    }
}
