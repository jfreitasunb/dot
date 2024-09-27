import Adw from 'gi://Adw';
import Gio from 'gi://Gio';
import Gtk from 'gi://Gtk';
import {ExtensionPreferences} from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';
import * as Settings from './settings.js';
import * as Utils from './utils.js';
import * as WallpaperManager from './manager/wallpaperManager.js';
import {Logger} from './logger.js';
import {SourceRow} from './ui/sourceRow.js';
import {SourceConfigModal} from './ui/sourceConfigModal.js';

// https://gjs.guide/extensions/overview/anatomy.html#prefs-js
// The code in prefs.js will be executed in a separate Gtk process
// Here you will not have access to code running in GNOME Shell, but fatal errors or mistakes will be contained within that process.
// In this process you will be using the Gtk toolkit, not Clutter.
/**
 * Main settings class for everything related to the settings window.
 */
class RandomWallpaperSettings extends ExtensionPreferences {
    constructor() {
        super(...arguments);

        // timer state before the settings where opened
        this.pauseTimerState = false;
    }

    /**
     * This function is called when the preferences window is first created to fill
     * the `Adw.PreferencesWindow`.
     *
     * @param {Adw.PreferencesWindow} window - The preferences window
     */
    fillPreferencesWindow(window) {
        // Set statics for the current extension context (preferences window)
        Settings.Settings.extensionContext = ExtensionPreferences;
        const settings = new Settings.Settings();
        Logger.SETTINGS = settings;
        const backendConnection = new Settings.Settings(Settings.RWG_SETTINGS_SCHEMA_BACKEND_CONNECTION);
        const builder = new Gtk.Builder();
        const sources = this._loadSources(settings);
        window.set_default_size(600, 720);
        window.set_search_enabled(true);

        // save the current pause-timer state before pausing
        this.pauseTimerState = backendConnection.getBoolean('pause-timer');

        // pause timer while in settings
        backendConnection.setBoolean('pause-timer', true);

        // observe the pause-timer
        backendConnection.observe('pause-timer', () => {
            this.pauseTimerState = backendConnection.getBoolean('pause-timer');
        });
        const extensionObject = ExtensionPreferences.lookupByURL(import.meta.url);

        if (!extensionObject) {
            Logger.error('Own extension object not found!', this);
            throw new Error('Own extension object not found!');
        }


        // this._builder.set_translation_domain(extensionObject.metadata['gettext-domain']);
        builder.add_from_file(`${extensionObject.path}/ui/pageGeneral.ui`);
        builder.add_from_file(`${extensionObject.path}/ui/pageSources.ui`);
        const comboBackgroundType = this._getAs(builder, 'combo_background_type');
        comboBackgroundType.model = Gtk.StringList.new(WallpaperManager.getModeNameList());
        settings.bind('change-type', comboBackgroundType, 'selected', Gio.SettingsBindFlags.DEFAULT);
        const comboScalingMode = this._getAs(builder, 'combo_scaling_mode');
        comboScalingMode.model = Gtk.StringList.new(WallpaperManager.getScalingModeEnum());
        const gnomeDesktopSettings = new Settings.Settings('org.gnome.desktop.background');
        const gnomeScreensaverSettings = new Settings.Settings('org.gnome.desktop.screensaver');

        let storedScalingModeIdx = WallpaperManager.getScalingModeEnum().indexOf(settings.getString('scaling-mode'));

        if (storedScalingModeIdx < 0)

            // fallback to the current value set in gnome-shell for the desktop
            storedScalingModeIdx = WallpaperManager.getScalingModeEnum().indexOf(gnomeDesktopSettings.getString('picture-options'));


        // can't bind a string to "selected" and "active-item" is not available on Adw.ComboRow, binding is implemented manually below
        comboScalingMode.selected = storedScalingModeIdx >= 0 ? storedScalingModeIdx : Gtk.INVALID_LIST_POSITION;
        comboScalingMode.connect('notify::selected', () => {
            const selectedString = WallpaperManager.getScalingModeEnum()[comboScalingMode.selected];
            gnomeDesktopSettings.setString('picture-options', selectedString);
            gnomeScreensaverSettings.setString('picture-options', selectedString);
            settings.setString('scaling-mode', selectedString);
        });
        const comboLogLevel = this._getAs(builder, 'log_level');
        comboLogLevel.model = Gtk.StringList.new(Logger.getLogLevelNameList());
        settings.bind('log-level', comboLogLevel, 'selected', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('minutes', this._getAs(builder, 'duration_minutes'), 'value', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('hours', this._getAs(builder, 'duration_hours'), 'value', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('auto-fetch', this._getAs(builder, 'af_switch'), 'enable-expansion', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('disable-hover-preview', this._getAs(builder, 'disable_hover_preview'), 'active', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('hide-panel-icon', this._getAs(builder, 'hide_panel_icon'), 'active', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('show-notifications', this._getAs(builder, 'show_notifications'), 'active', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('fetch-on-startup', this._getAs(builder, 'fetch_on_startup'), 'active', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('general-post-command', this._getAs(builder, 'general_post_command'), 'text', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('multiple-displays', this._getAs(builder, 'enable_multiple_displays'), 'active', Gio.SettingsBindFlags.DEFAULT);
        this._bindButtons(settings, backendConnection, builder, sources, window);
        this._bindHistorySection(settings, backendConnection, builder, window);

        // Disable/enable features depending on the backend connection.
        const backendAvailableChangedHandler = () => {
            const backendAvailable = backendConnection.getBoolean('backend-connection-available');
            this._getAs(builder, 'request_new_wallpaper').sensitive = backendAvailable;
            this._getAs(builder, 'open_wallpaper_folder').sensitive = backendAvailable;
            this._getAs(builder, 'clear_history').sensitive = backendAvailable;
        };
        backendConnection.observe('backend-connection-available', () => backendAvailableChangedHandler());
        backendAvailableChangedHandler();
        window.connect('close-request', () => {
            backendConnection.setBoolean('pause-timer', this.pauseTimerState);
            Settings.Settings.extensionContext = undefined;
            Logger.destroy();
        });
        window.add(this._getAs(builder, 'page_general'));
        window.add(this._getAs(builder, 'page_sources'));

        if (sources.length === 0)
            this._getAs(builder, 'placeholder_no_source').show();

        sources.forEach(id => {
            const sourceRow = new SourceRow(id);
            this._addSourceRow(window, settings, builder, sources, sourceRow);
        });
        const manager = Utils.getWallpaperManager();

        if (manager.canHandleMultipleImages)
            this._getAs(builder, 'multiple_displays_row').set_sensitive(true);
    }

    /**
     * Bind button clicks to logic.
     *
     * @param {Settings.Settings} settings Settings object holding general settings
     * @param {Settings.Settings} backendConnection Settings object holding backend settings
     * @param {Gtk.Builder} builder Gtk builder of the preference window
     * @param {string[]} sources String array of sources to process
     * @param {Adw.PreferencesWindow} window Current preferences window
     */
    _bindButtons(settings, backendConnection, builder, sources, window) {
        const newWallpaperButton = this._getAs(builder, 'request_new_wallpaper');
        const newWallpaperButtonLabel = newWallpaperButton.get_child();
        const origNewWallpaperText = newWallpaperButtonLabel?.get_label() ?? 'Request New Wallpaper';
        newWallpaperButton.connect('activated', () => {
            newWallpaperButtonLabel?.set_label('Loading ...');
            newWallpaperButton.set_sensitive(false);

            // The backend sets this back to false after fetching the image - listen for that event.
            const handler = backendConnection.observe('request-new-wallpaper', () => {
                if (!backendConnection.getBoolean('request-new-wallpaper')) {
                    newWallpaperButtonLabel?.set_label(origNewWallpaperText);
                    newWallpaperButton.set_sensitive(true);
                    backendConnection.disconnect(handler);
                }
            });
            backendConnection.setBoolean('request-new-wallpaper', true);
        });
        builder.get_object('button_new_source')?.connect('clicked', () => {
            new SourceConfigModal(window).open()
                .then(sourceRow => {
                    sources.push(String(sourceRow.id));
                    this._saveSources(settings, sources);
                    this._addSourceRow(window, settings, builder, sources, sourceRow);
                }).catch(() => {
                // nothing to do
                });
        });
        const extensionObject = ExtensionPreferences.lookupByURL(import.meta.url);

        if (!extensionObject) {
            Logger.error('Own extension object not found!', this);
            throw new Error('Own extension object not found!');
        }

        builder.get_object('open_about')?.connect('activated', () => {
            const about_window = new Adw.AboutWindow({
                title: 'About',
                transient_for: window,
                modal: true,
                licenseType: Gtk.License.MIT_X11,
                application_name: extensionObject.metadata['name'],
                website: extensionObject.metadata.url,
                issue_url: extensionObject.metadata['issue-url'],
                comments: extensionObject.metadata.description,
                version: `${extensionObject.metadata['semantic-version']} (${extensionObject.metadata.version})`,
            });
            about_window.show();
        });
    }

    /**
     * Bind button clicks related to the history.
     *
     * @param {Settings.Settings} settings Settings object holding general settings
     * @param {Settings.Settings} backendConnection Settings object holding backend settings
     * @param {Gtk.Builder} builder Gtk builder of the preference window
     * @param {Adw.PreferencesWindow} window Preferences window
     */
    _bindHistorySection(settings, backendConnection, builder, window) {
        const entryRow = this._getAs(builder, 'row_favorites_folder');
        entryRow.text = settings.getString('favorites-folder');
        settings.bind('history-length', this._getAs(builder, 'history_length'), 'value', Gio.SettingsBindFlags.DEFAULT);
        settings.bind('favorites-folder', entryRow, 'text', Gio.SettingsBindFlags.DEFAULT);
        builder.get_object('clear_history')?.connect('clicked', () => {
            backendConnection.setBoolean('clear-history', true);
        });
        builder.get_object('open_wallpaper_folder')?.connect('clicked', () => {
            backendConnection.setBoolean('open-folder', true);
        });
        builder.get_object('button_favorites_folder')?.connect('clicked', () => {
            // For GTK 4.10+
            // Gtk.FileDialog();
            // https://stackoverflow.com/a/54487948
            this._saveDialog = new Gtk.FileChooserNative({
                title: 'Choose a Wallpaper Folder',
                action: Gtk.FileChooserAction.SELECT_FOLDER,
                accept_label: 'Open',
                cancel_label: 'Cancel',
                transient_for: window,
                modal: true,
            });
            this._saveDialog.connect('response', (dialog, response_id) => {
                if (response_id === Gtk.ResponseType.ACCEPT) {
                    const text = dialog.get_file()?.get_path();

                    if (text)
                        entryRow.text = text;
                }

                dialog.destroy();
            });
            this._saveDialog.show();
        });
    }

    /**
     * Load the config from the schema
     *
     * @param {Settings.Settings} settings Settings object used for loading
     * @returns {string[]} Array of strings of loaded sources
     */
    _loadSources(settings) {
        const sources = settings.getStrv('sources');

        // this._sources.sort((a, b) => {
        // const path1 = `${Settings.RWG_SETTINGS_SCHEMA_PATH}/sources/general/${a}/`;
        // const settingsGeneral1 = new Settings.Settings(Settings.RWG_SETTINGS_SCHEMA_SOURCES_GENERAL, path1);
        // const path2 = `${Settings.RWG_SETTINGS_SCHEMA_PATH}/sources/general/${b}/`;
        // const settingsGeneral2 = new Settings.Settings(Settings.RWG_SETTINGS_SCHEMA_SOURCES_GENERAL, path2);
        // const nameA = settingsGeneral1.get('name', 'string').toUpperCase();
        // const nameB = settingsGeneral2.get('name', 'string').toUpperCase();
        // return nameA.localeCompare(nameB);
        // });
        sources.sort((a, b) => {
            const path1 = `${Settings.RWG_SETTINGS_SCHEMA_PATH}/sources/general/${a}/`;
            const settingsGeneral1 = new Settings.Settings(Settings.RWG_SETTINGS_SCHEMA_SOURCES_GENERAL, path1);
            const path2 = `${Settings.RWG_SETTINGS_SCHEMA_PATH}/sources/general/${b}/`;
            const settingsGeneral2 = new Settings.Settings(Settings.RWG_SETTINGS_SCHEMA_SOURCES_GENERAL, path2);

            return settingsGeneral1.getInt('type') - settingsGeneral2.getInt('type');
        });

        return sources;
    }

    /**
     * Save all configured sources to the settings.
     *
     * @param {Settings.Settings} settings Settings object used for saving
     * @param {string[]} sources String array of sources to save
     */
    _saveSources(settings, sources) {
        settings.setStrv('sources', sources);
    }

    /**
     * Add and configure a new source in the source list.
     *
     * @param {Adw.PreferencesWindow} window The current preferences window
     * @param {Settings.Settings} settings Settings object holding backend settings
     * @param {Gtk.Builder} builder Gtk builder of the preference window
     * @param {string[]} sources The IDs of the currently configured sources
     * @param {SourceRow} sourceRow The new source to add
     */
    _addSourceRow(window, settings, builder, sources, sourceRow) {
        this._getAs(builder, 'sources_list').add(sourceRow);
        this._getAs(builder, 'placeholder_no_source').hide();
        sourceRow.button_remove.connect('clicked', () => {
            sourceRow.clearConfig();
            Utils.removeItemOnce(sources, sourceRow.id);
            this._saveSources(settings, sources);
            this._getAs(builder, 'sources_list').remove(sourceRow);

            if (sources.length === 0)
                this._getAs(builder, 'placeholder_no_source').show();
        });
        sourceRow.button_edit.connect('clicked', () => {
            void new SourceConfigModal(window, sourceRow).open();
        });
    }

    /**
     * Gets a named object from a Gtk.Builder, ensures it is not null, and returns it with the requested type
     *
     * @param {Gtk.Builder} builder Builder to get object from
     * @param {string} key Name of the object to get
     * @returns The object with the provided type
     */
    _getAs(builder, key) {
        const obj = builder.get_object(key);

        if (obj === undefined || obj === null)
            throw new Error(`Could not get object with key ${key} from builder`);

        return obj;
    }
}

export {RandomWallpaperSettings as default};
