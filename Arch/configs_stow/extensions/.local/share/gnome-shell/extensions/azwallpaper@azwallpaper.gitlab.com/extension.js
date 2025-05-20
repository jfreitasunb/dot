import Clutter from 'gi://Clutter';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import GObject from 'gi://GObject';
import St from 'gi://St';

import * as Config from 'resource:///org/gnome/shell/misc/config.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import * as QuickSettings from 'resource:///org/gnome/shell/ui/quickSettings.js';

import {Extension, gettext as _, InjectionManager} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as LoginManager from 'resource:///org/gnome/shell/misc/loginManager.js';

import {BingWallpaperDownloader} from './bingWallpaperDownloader.js';
import {Slideshow} from './slideshow.js';
import {UpdateNotification} from './updateNotifier.js';

const [ShellVersion] = Config.PACKAGE_VERSION.split('.').map(s => Number(s));

export default class AzWallpaper extends Extension {
    enable() {
        this._settings = this.getSettings();

        this._logger = new Logger(this._settings);

        this._slideshow = new Slideshow(this);
        this._bingWallpaperDownloader = new BingWallpaperDownloader(this);
        this._injectionManager = new InjectionManager();

        this._createQuickSettingsEntry();
        this._updateNotification = new UpdateNotification(this);

        this._injectionManager.overrideMethod(Main.layoutManager, '_addBackgroundMenu', originalMethod => {
            const azWallpaper = this;
            return function (bgManager) {
                /* eslint-disable-next-line no-invalid-this */
                originalMethod.call(this, bgManager);
                const menu = bgManager.backgroundActor._backgroundMenu;
                azWallpaper._modifyBackgroundMenu(menu);
            };
        });

        this._settings.connectObject('changed::bing-wallpaper-download', () => this._bingWallpaperDownloadChanged(), this);
        this._settings.connectObject('changed::bing-download-directory', () => this._restartBingWallpaperDownloader(), this);
        this._settings.connectObject('changed::bing-wallpaper-market', () => this._restartBingWallpaperDownloader(), this);
        this._settings.connectObject('changed::bing-wallpaper-download-count', () => this._restartBingWallpaperDownloader(), this);
        this._settings.connectObject('changed::bing-wallpaper-resolution', () => this._restartBingWallpaperDownloader(), this);
        this._settings.connectObject('changed::bing-wallpaper-delete-old', () => {
            const [deletionEnabled, daysToDeletion_] = this._settings.get_value('bing-wallpaper-delete-old').deep_unpack();
            if (deletionEnabled)
                this._bingWallpaperDownloader.maybeDeleteOldWallpapers();
            else
                this._settings.set_strv('bing-wallpapers-downloaded', []);
        }, this);
        this._settings.connectObject('changed::slideshow-show-quick-settings-entry', () => this._createQuickSettingsEntry(), this);

        if (!Main.layoutManager._startingUp) {
            this._startExtension();
        } else {
            Main.layoutManager.connectObject('startup-complete', () =>
                this._startExtension(), this);
        }

        // Connect to a few signals to store the remaining time of a slide.
        // disable() isn't called on shutdown, restart, etc.
        const loginManager = LoginManager.getLoginManager();
        loginManager.connectObject('prepare-for-sleep', () =>
            this._slideshow?.saveTimer(), this);

        global.connectObject('shutdown', () =>
            this._slideshow?.saveTimer(), this);

        global.display.connectObject('x11-display-closing', () =>
            this._slideshow?.saveTimer(), this);
    }

    _startExtension() {
        this._delayStartId = GLib.timeout_add_seconds(GLib.PRIORITY_LOW, 3, () => {
            if (this._settings.get_boolean('bing-wallpaper-download'))
                this._bingWallpaperDownloader.initiate();

            Main.layoutManager._updateBackgrounds();

            this._delayStartId = null;
            return GLib.SOURCE_REMOVE;
        });
    }

    get settings() {
        return this._settings;
    }

    get slideshow() {
        return this._slideshow;
    }

    disable() {
        if (this._delayStartId) {
            GLib.source_remove(this._delayStartId);
            this._delayStartId = null;
        }

        this._injectionManager.clear();
        this._injectionManager = null;

        Main.layoutManager._updateBackgrounds();

        const loginManager = LoginManager.getLoginManager();
        loginManager.disconnectObject(this);

        Main.layoutManager.disconnectObject(this);
        global.display.disconnectObject(this);
        global.disconnectObject(this);
        this._settings.disconnectObject(this);

        this._logger.destroy();
        this._logger = null;

        if (this._quickMenuItem) {
            this._quickMenuItem.destroy();
            this._quickMenuItem = null;
        }

        this._updateNotification.destroy();
        this._updateNotification = null;
        this._bingWallpaperDownloader.destroy();
        this._bingWallpaperDownloader = null;
        this._slideshow.destroy();
        this._slideshow = null;
        this._settings = null;
    }

    _bingWallpaperDownloadChanged() {
        this._bingWallpaperDownloader.disable();
        if (this._settings.get_boolean('bing-wallpaper-download'))
            this._bingWallpaperDownloader.initiate();
    }

    _restartBingWallpaperDownloader() {
        this._bingWallpaperDownloader.endSingleDownload();
        this._bingWallpaperDownloader.endDownloadTimer();
        if (this._settings.get_boolean('bing-wallpaper-download')) {
            this._bingWallpaperDownloader.setBingParams();
            this._bingWallpaperDownloader.setDownloadDirectory();
            this._bingWallpaperDownloader.downloadOnceWithDelay();
        }
    }

    _modifyBackgroundMenu(menu) {
        menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem(), 4);

        let menuItem = new PopupMenu.PopupMenuItem(_('Previous Wallpaper'));
        menuItem.connect('activate', () => {
            Logger.log('\'Previous Wallpaper\' clicked.');
            this._slideshow.goToPreviousSlide();
        });
        menu.addMenuItem(menuItem, 5);

        menuItem = new PopupMenu.PopupMenuItem(_('Next Wallpaper'));
        menuItem.connect('activate', () => {
            Logger.log('\'Next Wallpaper\' clicked.');
            this._slideshow.goToNextSlide();
        });
        menu.addMenuItem(menuItem, 6);

        menuItem = new PopupMenu.PopupMenuItem(_('Slideshow Settings'));
        menuItem.connect('activate', () => this.openPreferences());
        menu.addMenuItem(menuItem, 7);
    }

    _createQuickSettingsEntry() {
        const showQuickSettingsEntry = this._settings.get_boolean('slideshow-show-quick-settings-entry');

        if (this._quickMenuItem) {
            this._quickMenuItem.destroy();
            this._quickMenuItem = null;
        }

        if (showQuickSettingsEntry)
            this._quickMenuItem = new SlideshowQuickMenu(this);
    }

    openPreferences() {
        // Find if an extension preferences window is already open
        const prefsWindow = global.get_window_actors().map(wa => wa.meta_window).find(w => w.wm_class === 'org.gnome.Shell.Extensions');

        if (!prefsWindow) {
            super.openPreferences();
            return;
        }

        // The current prefsWindow belongs to this extension, activate it
        if (prefsWindow.title === this.metadata.name) {
            Main.activateWindow(prefsWindow);
            return;
        }

        // If another extension's preferences are open, close it and open this extension's preferences
        prefsWindow.connectObject('unmanaged', () => {
            super.openPreferences();
            prefsWindow.disconnectObject(this);
        }, this);
        prefsWindow.delete(global.get_current_time());
    }
}

export class Logger {
    constructor(settings) {
        Logger.settings = settings;
    }

    static log(msg) {
        if (Logger.settings?.get_boolean('debug-logs'))
            console.log(`Wallpaper Slideshow: ${msg}`);
    }

    destroy() {
        Logger.settings = null;
    }
}

const SlideshowQuickMenu = GObject.registerClass(
class SlideshowQuickMenu extends QuickSettings.QuickMenuToggle {
    _init(extension) {
        super._init({
            icon_name: 'image-x-generic-symbolic',
            title: _('Slideshow'),
            checked: true,
        });

        this.connect('clicked', () => this.menu.open());

        const {slideshow} = extension;

        const quickSettings = Main.panel.statusArea.quickSettings;
        const backgroundApps = quickSettings._backgroundApps?.quickSettingsItems?.at(-1) ?? null;
        quickSettings.menu.insertItemBefore(this, backgroundApps);

        this.menu.setHeader('image-x-generic-symbolic', _('Wallpaper Slideshow'));

        const currentSlideInfo = new SlideInfoMenuItem(slideshow);
        this.menu.addMenuItem(currentSlideInfo);

        const slideControlsMenuItem = new SlideControlsMenuItem(extension);
        this.menu.addMenuItem(slideControlsMenuItem);

        this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());

        const settingsMenuItem = new PopupMenu.PopupMenuItem(_('Slideshow Settings'));
        settingsMenuItem.connect('activate', () => {
            Main.panel.closeQuickSettings();
            extension.openPreferences();
        });
        this.menu.addMenuItem(settingsMenuItem);
    }
});

const SlideInfoMenuItem = GObject.registerClass(
class SlideInfoMenuItem extends PopupMenu.PopupMenuItem {
    _init(slideshow) {
        super._init(_('Current Slide'));

        if (ShellVersion >= 48)
            this.orientation = Clutter.Orientation.VERTICAL;
        else
            this.vertical = true;

        this.subLabel = new St.Label({
            text: slideshow.getCurrentSlide().name ?? _('None'),
            y_expand: true,
            y_align: Clutter.ActorAlign.CENTER,
            style_class: 'device-subtitle',
        });
        this.add_child(this.subLabel);

        slideshow.connectObject('notify::slide-index', () => {
            this.subLabel.text = slideshow.getCurrentSlide().name ?? _('None');
        }, this);

        this.connect('activate', () => {
            Main.panel.closeQuickSettings();
            const filePath = slideshow.getCurrentSlide().path;
            if (!filePath)
                return;

            const fileUri = Gio.File.new_for_path(filePath).get_uri();
            try {
                Gio.AppInfo.launch_default_for_uri(fileUri, null);
            } catch (e) {
                console.log(e, `Failed to open URI: ${fileUri}`);
            }
        });
    }
});

const SlideControlsMenuItem = GObject.registerClass(
class SlideControlsMenuItem extends PopupMenu.PopupMenuItem {
    _init(extension) {
        super._init(_('Change Current Slide'), {
            activate: false,
            hover: false,
        });
        this.track_hover = false;

        const {slideshow} = extension;

        const goNextButton = new St.Button({
            icon_name: 'media-seek-forward-symbolic',
            style_class: 'icon-button',
            x_align: Clutter.ActorAlign.END,
        });
        goNextButton.connect('clicked', () => {
            slideshow.goToNextSlide();
        });

        const goPrevButton = new St.Button({
            icon_name: 'media-seek-backward-symbolic',
            style_class: 'icon-button',
            x_expand: true,
            x_align: Clutter.ActorAlign.END,
        });
        goPrevButton.connect('clicked', () => {
            slideshow.goToPreviousSlide();
        });

        this.add_child(goPrevButton);
        this.add_child(goNextButton);
    }
});
