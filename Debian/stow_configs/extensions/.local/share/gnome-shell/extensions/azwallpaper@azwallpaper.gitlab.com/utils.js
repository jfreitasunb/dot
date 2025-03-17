const {Gio} = imports.gi;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const Gettext = imports.gettext.domain('azwallpaper');
const _ = Gettext.gettext;

const {
    main: Main,
    messageTray: MessageTray,
} = imports.ui;

/**
 *
 * @param {string} message the message to log
 */
function debugLog(message) {
    if (Me.settings.get_boolean('debug-logs'))
        log(`Wallpaper Slideshow: ${message}`);
}

/**
 *
 * @param {string} msg A message
 * @param {string} details Additional information
 * @param {Label} actionLabel the label for the action
 * @param {Function} actionCallback the callback for the action
 */
function notify(msg, details, actionLabel = null, actionCallback = null) {
    const source = new MessageTray.SystemNotificationSource();
    Main.messageTray.add(source);
    msg = `${_('Wallpaper Slideshow')}: ${msg}`;
    const notification = new MessageTray.Notification(source, msg, details, {
        gicon: Gio.icon_new_for_string(`${Me.path}/media/azwallpaper-logo.svg`),
    });

    if (actionLabel && actionCallback) {
        notification.setUrgency(MessageTray.Urgency.CRITICAL);
        notification.addAction(actionLabel, actionCallback);
    } else {
        notification.setTransient(true);
    }

    source.showNotification(notification);
}
