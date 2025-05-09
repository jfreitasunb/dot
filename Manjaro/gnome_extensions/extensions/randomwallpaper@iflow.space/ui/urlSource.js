var _a, _b, _c, _d;
import Adw from 'gi://Adw';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import GObject from 'gi://GObject';
import Gtk from 'gi://Gtk';
import * as Settings from './../settings.js';

// FIXME: Generated static class code produces a no-unused-expressions rule error
/* eslint-disable no-unused-expressions */
/**
 * Subclass containing the preferences for UrlSource adapter
 */
class UrlSourceSettings extends Adw.PreferencesPage {
    /**
     * Craft a new adapter using an unique ID.
     *
     * Previously saved settings will be used if the adapter and ID match.
     *
     * @param {string} id Unique ID
     */
    constructor(id) {
        super(undefined);
        const path = `${Settings.RWG_SETTINGS_SCHEMA_PATH}/sources/urlSource/${id}/`;
        this._settings = new Settings.Settings(Settings.RWG_SETTINGS_SCHEMA_SOURCES_URL_SOURCE, path);
        this._settings.bind('author-name', this._author_name, 'text', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('author-url', this._author_url, 'text', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('different-images', this._different_images, 'active', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('domain', this._domain, 'text', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('image-url', this._image_url, 'text', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('post-url', this._post_url, 'text', Gio.SettingsBindFlags.DEFAULT);
    }

    /**
     * Clear all config options associated to this specific adapter.
     */
    clearConfig() {
        this._settings.resetSchema();
    }
}
_a = UrlSourceSettings, _b = GObject.GTypeName, _c = Gtk.template, _d = Gtk.internalChildren;
UrlSourceSettings[_b] = 'UrlSourceSettings';

// @ts-expect-error Gtk.template is not in the type definitions files yet
UrlSourceSettings[_c] = GLib.uri_resolve_relative(import.meta.url, './urlSource.ui', GLib.UriFlags.NONE);

// @ts-expect-error Gtk.internalChildren is not in the type definitions files yet
UrlSourceSettings[_d] = [
    'author_name',
    'author_url',
    'different_images',
    'domain',
    'image_url',
    'post_url',
];
(() => {
    GObject.registerClass(_a);
})();
export {UrlSourceSettings};
