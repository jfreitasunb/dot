var _a, _b, _c, _d;
import Adw from 'gi://Adw';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import GObject from 'gi://GObject';
import Gtk from 'gi://Gtk';
import * as Settings from './../settings.js';

// Generated code produces a no-shadow rule error
/* eslint-disable */
var ConstraintType;
(function (ConstraintType) {
    ConstraintType[ConstraintType["UNCONSTRAINED"] = 0] = "UNCONSTRAINED";
    ConstraintType[ConstraintType["USER"] = 1] = "USER";
    ConstraintType[ConstraintType["USERS_LIKES"] = 2] = "USERS_LIKES";
    ConstraintType[ConstraintType["COLLECTION_ID"] = 3] = "COLLECTION_ID";
})(ConstraintType || (ConstraintType = {}));
/* eslint-enable */
// FIXME: Generated static class code produces a no-unused-expressions rule error
/* eslint-disable no-unused-expressions */
/**
 * Subclass containing the preferences for Unsplash adapter
 */
class UnsplashSettings extends Adw.PreferencesPage {
    /**
     * Craft a new adapter using an unique ID.
     *
     * Previously saved settings will be used if the adapter and ID match.
     *
     * @param {string} id Unique ID
     */
    constructor(id) {
        super(undefined);
        const path = `${Settings.RWG_SETTINGS_SCHEMA_PATH}/sources/unsplash/${id}/`;
        this._settings = new Settings.Settings(Settings.RWG_SETTINGS_SCHEMA_SOURCES_UNSPLASH, path);

        if (!UnsplashSettings._stringList)
            UnsplashSettings._stringList = Gtk.StringList.new(getConstraintTypeNameList());

        this._constraint_type.model = UnsplashSettings._stringList;
        this._settings.bind('constraint-type', this._constraint_type, 'selected', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('constraint-value', this._constraint_value, 'text', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('featured-only', this._featured_only, 'active', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('image-width', this._image_width, 'value', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('image-height', this._image_height, 'value', Gio.SettingsBindFlags.DEFAULT);
        this._settings.bind('keyword', this._keyword, 'text', Gio.SettingsBindFlags.DEFAULT);
        this._unsplashUnconstrained(this._constraint_type, true, this._featured_only);
        this._unsplashUnconstrained(this._constraint_type, false, this._constraint_value);
        this._constraint_type.connect('notify::selected', comboRow => {
            this._unsplashUnconstrained(comboRow, true, this._featured_only);
            this._unsplashUnconstrained(comboRow, false, this._constraint_value);
            this._featured_only.set_active(false);
        });
    }

    /**
     * Switch element sensitivity based on a selected combo row entry.
     *
     * @param {Adw.ComboRow} comboRow ComboRow with selected entry
     * @param {boolean} enable Whether to make the element sensitive
     * @param {Gtk.Widget} targetElement The element to target the sensitivity setting
     */
    _unsplashUnconstrained(comboRow, enable, targetElement) {
        if (comboRow.selected === 0)
            targetElement.set_sensitive(enable);
        else
            targetElement.set_sensitive(!enable);
    }

    /**
     * Clear all config options associated to this specific adapter.
     */
    clearConfig() {
        this._settings.resetSchema();
    }
}
_a = UnsplashSettings, _b = GObject.GTypeName, _c = Gtk.template, _d = Gtk.internalChildren;
UnsplashSettings[_b] = 'UnsplashSettings';

// @ts-expect-error Gtk.template is not in the type definitions files yet
UnsplashSettings[_c] = GLib.uri_resolve_relative(import.meta.url, './unsplash.ui', GLib.UriFlags.NONE);

// @ts-expect-error Gtk.internalChildren is not in the type definitions files yet
UnsplashSettings[_d] = [
    'constraint_type',
    'constraint_value',
    'featured_only',
    'image_height',
    'image_width',
    'keyword',
];
(() => {
    GObject.registerClass(_a);
})();

/**
 * Retrieve the human readable enum name.
 *
 * @param {ConstraintType} type The type to name
 * @returns {string} Name
 */
function _getConstraintTypeName(type) {
    let name;

    switch (type) {
    case ConstraintType.UNCONSTRAINED:
        name = 'Unconstrained';
        break;
    case ConstraintType.USER:
        name = 'User';
        break;
    case ConstraintType.USERS_LIKES:
        name = 'User\'s Likes';
        break;
    case ConstraintType.COLLECTION_ID:
        name = 'Collection ID';
        break;
    default:
        name = 'Constraint type name not found';
        break;
    }

    return name;
}

/**
 * Get a list of human readable enum entries.
 *
 * @returns {string[]} Array with key names
 */
function getConstraintTypeNameList() {
    const list = [];
    const values = Object.values(ConstraintType).filter(v => !isNaN(Number(v)));

    for (const i of values)
        list.push(_getConstraintTypeName(i));

    return list;
}

export {UnsplashSettings};
