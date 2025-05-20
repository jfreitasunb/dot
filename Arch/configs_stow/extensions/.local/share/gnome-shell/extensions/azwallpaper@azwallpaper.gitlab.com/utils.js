import Gio from 'gi://Gio';

import * as Config from 'resource:///org/gnome/shell/misc/config.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as MessageTray from 'resource:///org/gnome/shell/ui/messageTray.js';

import {domain} from 'gettext';
const {gettext: _} = domain('azwallpaper');

const [ShellVersion] = Config.PACKAGE_VERSION.split('.').map(s => Number(s));
const PROJECT_NAME = _('Wallpaper Slideshow');

/**
 *
 * @param {string} title notification title
 * @param {string} body notification body
 * @param {string} actionLabel the label for the action
 * @param {Function} actionCallback the callback for the action
 */
export function notify(title, body, actionLabel = null, actionCallback = null) {
    const extension = Extension.lookupByURL(import.meta.url);
    const gicon = Gio.icon_new_for_string(`${extension.path}/media/azwallpaper-logo.svg`);

    const source = getSource(PROJECT_NAME, 'application-x-addon-symbolic');
    Main.messageTray.add(source);

    const notification = getNotification(source, title, body, gicon);
    notification.urgency = MessageTray.Urgency.CRITICAL;

    if (actionLabel && actionCallback) {
        notification.addAction(actionLabel, () => {
            actionCallback();
            notification.destroy();
        });
        notification.resident = true;
    } else {
        notification.isTransient = true;
    }

    if (ShellVersion >= 46)
        source.addNotification(notification);
    else
        source.showNotification(notification);
}

function getNotification(source, title, body, gicon) {
    if (ShellVersion >= 46)
        return new MessageTray.Notification({source, title, body, gicon});
    else
        return new MessageTray.Notification(source, title, body, {gicon});
}

function getSource(title, iconName) {
    if (ShellVersion >= 46)
        return new MessageTray.Source({title, iconName});
    else
        return new MessageTray.Source(title, iconName);
}
