var _a, _b, _c, _d, _e;
import Adw from 'gi://Adw';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import GObject from 'gi://GObject';
import Gtk from 'gi://Gtk';
import * as Settings from './../settings.js';
import * as Utils from './../utils.js';
import {Logger} from './../logger.js';
import {GenericJsonSettings} from './genericJson.js';
import {LocalFolderSettings} from './localFolder.js';
import {RedditSettings} from './reddit.js';
import {UnsplashSettings} from './unsplash.js';
import {UrlSourceSettings} from './urlSource.js';
import {WallhavenSettings} from './wallhaven.js';

// FIXME: Generated static class code produces a no-unused-expressions rule error
/* eslint-disable no-unused-expressions */
/**
 * Class containing general settings for each adapter source as well as the adapter source
 */
class SourceRow extends Adw.ExpanderRow {
    /**
     * Craft a new source row using an unique ID.
     *
     * Default unique ID is Date.now()
     * Previously saved settings will be used if the ID matches.
     *
     * @param {string | null} id Unique ID or null
     */
    constructor(id) {
        super(undefined);
        this.id = String(Date.now());
        this.blockedImageWidgets = [];

        if (id)
            this.id = id;

        const path = `${Settings.RWG_SETTINGS_SCHEMA_PATH}/sources/general/${this.id}/`;
        this.settings = new Settings.Settings(Settings.RWG_SETTINGS_SCHEMA_SOURCES_GENERAL, path);
        this.title = this.settings.getString('name');
        this.subtitle = Utils.getSourceTypeName(this.settings.getInt('type'));
        this.settings.bind('name', this, 'title', Gio.SettingsBindFlags.DEFAULT);
        this.settings.observe('type', () => {
            this.subtitle = Utils.getSourceTypeName(this.settings.getInt('type'));
        });
        this.settings.bind('enabled', this._switch_enable, 'active', Gio.SettingsBindFlags.DEFAULT);
        this.settings.observe('blocked-images', () => this._updateBlockedImages());
        this._updateBlockedImages();
    }

    /**
     * Get a new adapter based on an enum source type.
     *
     * @param {Utils.SourceType} type Enum of the adapter to get
     * @returns {UnsplashSettings | WallhavenSettings | RedditSettings | GenericJsonSettings | LocalFolderSettings | UrlSourceSettings | null} Newly crafted adapter or null
     */
    _getSettingsWidget(type = Utils.SourceType.UNSPLASH) {
        let targetWidget = null;

        switch (type) {
        case Utils.SourceType.UNSPLASH:
            targetWidget = new UnsplashSettings(this.id);
            break;
        case Utils.SourceType.WALLHAVEN:
            targetWidget = new WallhavenSettings(this.id);
            break;
        case Utils.SourceType.REDDIT:
            targetWidget = new RedditSettings(this.id);
            break;
        case Utils.SourceType.GENERIC_JSON:
            targetWidget = new GenericJsonSettings(this.id);
            break;
        case Utils.SourceType.LOCAL_FOLDER:
            targetWidget = new LocalFolderSettings(this.id);
            break;
        case Utils.SourceType.STATIC_URL:
            targetWidget = new UrlSourceSettings(this.id);
            break;
        default:
            targetWidget = null;
            Logger.error('The selected source has no corresponding widget!', this);
            break;
        }

        return targetWidget;
    }

    /**
     * Remove an image name from the blocked image list.
     *
     * @param {string} filename Image name to remove
     */
    _removeBlockedImage(filename) {
        let blockedImages = this.settings.getStrv('blocked-images');

        if (!blockedImages.includes(filename))
            return;

        blockedImages = Utils.removeItemOnce(blockedImages, filename);
        this.settings.setStrv('blocked-images', blockedImages);
    }

    /**
     * Clear all keys associated to this ID across all adapter
     */
    clearConfig() {
        for (const i of Array(6).keys()) {
            const widget = this._getSettingsWidget(i);

            if (widget)
                widget.clearConfig();
        }

        this.settings.resetSchema();
    }

    /**
     * Update the blocked images list of this source row entry.
     */
    _updateBlockedImages() {
        const blockedImages = this.settings.getStrv('blocked-images');

        if (blockedImages.length > 0)
            this._placeholder_no_blocked.hide();
        else
            this._placeholder_no_blocked.show();


        // remove all widget first
        for (const widget of this.blockedImageWidgets)
            this._blocked_images_list.remove(widget);

        this.blockedImageWidgets = [];
        blockedImages.forEach(filename => {
            const blockedImageRow = new Adw.ActionRow();
            blockedImageRow.set_title(filename);
            this.blockedImageWidgets.push(blockedImageRow);
            const button = new Gtk.Button();
            button.set_valign(Gtk.Align.CENTER);
            button.connect('clicked', () => {
                this._removeBlockedImage(filename);
                this._blocked_images_list.remove(blockedImageRow);
            });
            const buttonContent = new Adw.ButtonContent();
            buttonContent.set_icon_name('user-trash-symbolic');
            button.set_child(buttonContent);
            blockedImageRow.add_suffix(button);
            this._blocked_images_list.add(blockedImageRow);
        });
    }
}
_a = SourceRow, _b = GObject.GTypeName, _c = Gtk.template, _d = Gtk.children, _e = Gtk.internalChildren;
SourceRow[_b] = 'SourceRow';

// @ts-expect-error Gtk.template is not in the type definitions files yet
SourceRow[_c] = GLib.uri_resolve_relative(import.meta.url, './sourceRow.ui', GLib.UriFlags.NONE);

// @ts-expect-error Gtk.children is not in the type definitions files yet
SourceRow[_d] = [
    'button_remove',
    'button_edit',
];

// @ts-expect-error Gtk.internalChildren is not in the type definitions files yet
SourceRow[_e] = [
    'switch_enable',
    'blocked_images_list',
    'placeholder_no_blocked',
];
(() => {
    GObject.registerClass(_a);
})();
export {SourceRow};
