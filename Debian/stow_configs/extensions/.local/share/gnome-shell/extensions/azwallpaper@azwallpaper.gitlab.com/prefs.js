/* eslint-disable jsdoc/require-jsdoc */
const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const {Adw, Gdk, Gio, GLib, GObject, Gtk} = imports.gi;
const Config = imports.misc.config;
const Gettext = imports.gettext.domain(Me.metadata['gettext-domain']);
const _ = Gettext.gettext;

function init() {
    ExtensionUtils.initTranslations();
}

function fillPreferencesWindow(window) {
    const iconTheme = Gtk.IconTheme.get_for_display(Gdk.Display.get_default());
    if (!iconTheme.get_search_path().includes(`${Me.path}/media`))
        iconTheme.add_search_path(`${Me.path}/media`);

    const settings = ExtensionUtils.getSettings();

    window.can_navigate_back = true;

    const homePage = new HomePage(settings);
    window.add(homePage);

    const aboutPage = new AboutPage(Me.metadata);
    window.add(aboutPage);
}

var HomePage = GObject.registerClass(
class azWallpaperHomePage extends Adw.PreferencesPage {
    _init(settings) {
        super._init({
            title: _('Settings'),
            icon_name: 'preferences-system-symbolic',
            name: 'HomePage',
        });

        this._settings = settings;

        const slideShowGroup = new Adw.PreferencesGroup({
            title: _('Slideshow Options'),
        });
        this.add(slideShowGroup);

        const slideShowDirRow = new Adw.ActionRow({
            title: _('Slideshow Directory'),
            subtitle: this._settings.get_string('slideshow-directory'),
        });
        let fileChooserButton = this.createFileChooserButton('slideshow-directory', slideShowDirRow);
        let openDirectoryButton = this.createOpenDirectoyButton(this._settings.get_string('slideshow-directory'));
        slideShowDirRow.add_prefix(openDirectoryButton);
        slideShowDirRow.add_suffix(fileChooserButton);
        slideShowGroup.add(slideShowDirRow);

        const slideDurationRow = new Adw.ActionRow({
            title: _('Slide Duration'),
            subtitle: `${_('Hours')}:${_('Minutes')}:${_('Seconds')}`,
        });
        slideShowGroup.add(slideDurationRow);

        const updateSlideDuration = () => {
            if (this._updateTimeoutId)
                GLib.source_remove(this._updateTimeoutId);

            const hours = hoursSpinButton.get_value();
            const minutes = minutesSpinButton.get_value();
            const seconds = secondsSpinButton.get_value();

            this._updateTimeoutId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 500, () => {
                this._settings.set_value('slideshow-slide-duration', new GLib.Variant('(iii)', [hours, minutes, seconds]));
                this._updateTimeoutId = null;
                return GLib.SOURCE_REMOVE;
            });
        };

        const slideDurationGrid = new Gtk.Grid({
            row_spacing: 2,
            column_spacing: 4,
        });
        slideDurationRow.add_suffix(slideDurationGrid);

        const [hours, minutes, seconds] = this._settings.get_value('slideshow-slide-duration').deep_unpack();
        const hoursSpinButton = this._createSpinButton(hours, 0, 24);
        hoursSpinButton.connect('value-changed', () => {
            updateSlideDuration();
        });
        const hoursLabel = new Gtk.Label({
            label: '∶',
            css_classes: ['title-3'],
            halign: Gtk.Align.START,
        });

        const minutesSpinButton = this._createSpinButton(minutes, 0, 60);
        minutesSpinButton.connect('value-changed', () => {
            updateSlideDuration();
        });
        const minutesLabel = new Gtk.Label({
            label: '∶',
            css_classes: ['title-3'],
            halign: Gtk.Align.START,
        });

        const secondsSpinButton = this._createSpinButton(seconds, 0, 60);
        secondsSpinButton.connect('value-changed', () => {
            updateSlideDuration();
        });

        slideDurationGrid.attach(hoursSpinButton, 0, 0, 1, 1);
        slideDurationGrid.attach(hoursLabel, 1, 0, 1, 1);
        slideDurationGrid.attach(minutesSpinButton, 2, 0, 1, 1);
        slideDurationGrid.attach(minutesLabel, 3, 0, 1, 1);
        slideDurationGrid.attach(secondsSpinButton, 4, 0, 1, 1);

        const bingDlSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
            active: this._settings.get_boolean('bing-wallpaper-download'),
        });
        bingDlSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('bing-wallpaper-download', widget.get_active());
        });

        const bingDLGroup = new Adw.PreferencesGroup({
            title: _('Download BING wallpaper of the day'),
            header_suffix: bingDlSwitch,
        });
        this.add(bingDLGroup);

        const bingDlRow = new Adw.ActionRow({
            title: _('BING Download Directory'),
            subtitle: this._settings.get_string('bing-download-directory'),
        });
        fileChooserButton = this.createFileChooserButton('bing-download-directory', bingDlRow);
        openDirectoryButton = this.createOpenDirectoyButton(this._settings.get_string('bing-download-directory'));
        bingDlRow.add_suffix(fileChooserButton);
        bingDlRow.add_prefix(openDirectoryButton);
        bingDLGroup.add(bingDlRow);

        const debugLogsGroup = new Adw.PreferencesGroup({
            title: _('Debug Mode'),
        });
        this.add(debugLogsGroup);

        const debugLogsSwitch = new Gtk.Switch({
            valign: Gtk.Align.CENTER,
            active: this._settings.get_boolean('debug-logs'),
        });
        debugLogsSwitch.connect('notify::active', widget => {
            this._settings.set_boolean('debug-logs', widget.get_active());
        });
        const debugLogsRow = new Adw.ActionRow({
            title: _('Enable Logs'),
            activatable_widget: debugLogsSwitch,
        });
        debugLogsRow.add_suffix(debugLogsSwitch);
        debugLogsGroup.add(debugLogsRow);
    }

    createOpenDirectoyButton(directory) {
        const file = Gio.file_new_for_path(directory);
        const fileUri = file.get_uri();
        const button = new Gtk.Button({
            icon_name: 'folder-open-symbolic',
            tooltip_text: _('Open directory...'),
            valign: Gtk.Align.CENTER,
        });

        button.connect('clicked', () => {
            Gtk.show_uri(this.get_root(), fileUri, Gdk.CURRENT_TIME);
        });

        return button;
    }

    createFileChooserButton(setting, parentRow) {
        const fileChooserButton = new Gtk.Button({
            icon_name: 'folder-new-symbolic',
            tooltip_text: _('Choose new directory...'),
            valign: Gtk.Align.CENTER,
        });

        fileChooserButton.connect('clicked', () => {
            const dialog = new Gtk.FileChooserDialog({
                title: _('Select a directory'),
                transient_for: this.get_root(),
                action: Gtk.FileChooserAction.SELECT_FOLDER,
            });
            dialog.add_button('_Cancel', Gtk.ResponseType.CANCEL);
            dialog.add_button('_Select', Gtk.ResponseType.ACCEPT);

            dialog.connect('response', (self, response) => {
                if (response === Gtk.ResponseType.ACCEPT) {
                    const filePath = dialog.get_file().get_path();
                    this._settings.set_string(setting, filePath);
                    parentRow.subtitle = filePath;
                    dialog.destroy();
                } else if (response === Gtk.ResponseType.CANCEL) {
                    dialog.destroy();
                }
            });
            dialog.show();
        });

        parentRow.activatable_widget = fileChooserButton;
        return fileChooserButton;
    }

    _createSpinButton(value, lower, upper) {
        const spinButton = new Gtk.SpinButton({
            adjustment: new Gtk.Adjustment({
                lower, upper, step_increment: 1, page_increment: 1, page_size: 0,
            }),
            climb_rate: 1,
            digits: 0,
            numeric: true,
            valign: Gtk.Align.CENTER,
            wrap: true,
            value,
            orientation: Gtk.Orientation.VERTICAL,
            width_request: 40,

        });
        return spinButton;
    }
});

var AboutPage = GObject.registerClass(
class AzWallpaperAboutPage extends Adw.PreferencesPage {
    _init(metadata) {
        super._init({
            title: _('About'),
            icon_name: 'help-about-symbolic',
            name: 'AboutPage',
        });

        const PAYPAL_LINK = `https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=53CWA7NR743WC&item_name=Support+${metadata.name}&source=url`;
        const PROJECT_IMAGE = 'azwallpaper-logo';
        const SCHEMA_PATH = '/org/gnome/shell/extensions/azwallpaper/';

        // Project Logo, title, description-------------------------------------
        const projectHeaderGroup = new Adw.PreferencesGroup();
        const projectHeaderBox = new Gtk.Box({
            orientation: Gtk.Orientation.VERTICAL,
            hexpand: false,
            vexpand: false,
        });

        const projectImage = new Gtk.Image({
            margin_bottom: 5,
            icon_name: PROJECT_IMAGE,
            pixel_size: 100,
        });

        const projectTitleLabel = new Gtk.Label({
            label: _('Wallpaper Slideshow'),
            css_classes: ['title-1'],
            vexpand: true,
            valign: Gtk.Align.FILL,
        });

        projectHeaderBox.append(projectImage);
        projectHeaderBox.append(projectTitleLabel);
        projectHeaderGroup.add(projectHeaderBox);

        this.add(projectHeaderGroup);
        // -----------------------------------------------------------------------

        // Extension/OS Info and Links Group------------------------------------------------
        const infoGroup = new Adw.PreferencesGroup();

        const projectVersionRow = new Adw.ActionRow({
            title: _('Wallpaper Slideshow Version'),
        });
        projectVersionRow.add_suffix(new Gtk.Label({
            label: metadata.version.toString(),
            css_classes: ['dim-label'],
        }));
        infoGroup.add(projectVersionRow);

        if (metadata.commit) {
            const commitRow = new Adw.ActionRow({
                title: _('Git Commit'),
            });
            commitRow.add_suffix(new Gtk.Label({
                label: metadata.commit.toString(),
                css_classes: ['dim-label'],
            }));
            infoGroup.add(commitRow);
        }

        const gnomeVersionRow = new Adw.ActionRow({
            title: _('GNOME Version'),
        });
        gnomeVersionRow.add_suffix(new Gtk.Label({
            label: Config.PACKAGE_VERSION.toString(),
            css_classes: ['dim-label'],
        }));
        infoGroup.add(gnomeVersionRow);

        const osRow = new Adw.ActionRow({
            title: _('OS Name'),
        });

        const name = GLib.get_os_info('NAME');
        const prettyName = GLib.get_os_info('PRETTY_NAME');

        osRow.add_suffix(new Gtk.Label({
            label: prettyName ? prettyName : name,
            css_classes: ['dim-label'],
        }));
        infoGroup.add(osRow);

        const sessionTypeRow = new Adw.ActionRow({
            title: _('Windowing System'),
        });
        sessionTypeRow.add_suffix(new Gtk.Label({
            label: GLib.getenv('XDG_SESSION_TYPE') === 'wayland' ? 'Wayland' : 'X11',
            css_classes: ['dim-label'],
        }));
        infoGroup.add(sessionTypeRow);

        const gitlabRow = this._createLinkRow(_('Wallpaper Slideshow GitLab'), metadata.url);
        infoGroup.add(gitlabRow);

        const donateRow = this._createLinkRow(_('Donate via PayPal'), PAYPAL_LINK);
        infoGroup.add(donateRow);

        this.add(infoGroup);
        // -----------------------------------------------------------------------

        // Save/Load Settings----------------------------------------------------------
        const settingsGroup = new Adw.PreferencesGroup();
        const settingsRow = new Adw.ActionRow({
            title: _('Wallpaper Slideshow Settings'),
        });
        const loadButton = new Gtk.Button({
            label: _('Load'),
            valign: Gtk.Align.CENTER,
        });
        loadButton.connect('clicked', () => {
            this._showFileChooser(
                _('Load Settings'),
                {action: Gtk.FileChooserAction.OPEN},
                '_Open',
                filename => {
                    if (filename && GLib.file_test(filename, GLib.FileTest.EXISTS)) {
                        const settingsFile = Gio.File.new_for_path(filename);
                        const [success_, pid_, stdin, stdout, stderr] =
                            GLib.spawn_async_with_pipes(
                                null,
                                ['dconf', 'load', SCHEMA_PATH],
                                null,
                                GLib.SpawnFlags.SEARCH_PATH | GLib.SpawnFlags.DO_NOT_REAP_CHILD,
                                null
                            );

                        const outputStream = new Gio.UnixOutputStream({fd: stdin, close_fd: true});
                        GLib.close(stdout);
                        GLib.close(stderr);

                        outputStream.splice(settingsFile.read(null),
                            Gio.OutputStreamSpliceFlags.CLOSE_SOURCE |
                            Gio.OutputStreamSpliceFlags.CLOSE_TARGET,
                            null);
                    }
                }
            );
        });
        const saveButton = new Gtk.Button({
            label: _('Save'),
            valign: Gtk.Align.CENTER,
        });
        saveButton.connect('clicked', () => {
            this._showFileChooser(
                _('Save Settings'),
                {action: Gtk.FileChooserAction.SAVE},
                '_Save',
                filename => {
                    const file = Gio.file_new_for_path(filename);
                    const raw = file.replace(null, false, Gio.FileCreateFlags.NONE, null);
                    const out = Gio.BufferedOutputStream.new_sized(raw, 4096);

                    out.write_all(GLib.spawn_command_line_sync(`dconf dump ${SCHEMA_PATH}`)[1], null);
                    out.close(null);
                }
            );
        });
        settingsRow.add_suffix(saveButton);
        settingsRow.add_suffix(loadButton);
        settingsGroup.add(settingsRow);
        this.add(settingsGroup);
        // -----------------------------------------------------------------------

        const gnuSoftwareGroup = new Adw.PreferencesGroup();
        const gnuSofwareLabel = new Gtk.Label({
            label: _(GNU_SOFTWARE),
            use_markup: true,
            justify: Gtk.Justification.CENTER,
        });
        const gnuSofwareLabelBox = new Gtk.Box({
            orientation: Gtk.Orientation.VERTICAL,
            valign: Gtk.Align.END,
            vexpand: true,
        });
        gnuSofwareLabelBox.append(gnuSofwareLabel);
        gnuSoftwareGroup.add(gnuSofwareLabelBox);
        this.add(gnuSoftwareGroup);
    }

    _createLinkRow(title, uri) {
        const image = new Gtk.Image({
            icon_name: 'adw-external-link-symbolic',
            valign: Gtk.Align.CENTER,
        });
        const linkRow = new Adw.ActionRow({
            title: _(title),
            activatable: true,
        });
        linkRow.connect('activated', () => {
            Gtk.show_uri(this.get_root(), uri, Gdk.CURRENT_TIME);
        });
        linkRow.add_suffix(image);

        return linkRow;
    }

    _showFileChooser(title, params, acceptBtn, acceptHandler) {
        const dialog = new Gtk.FileChooserDialog({
            title: _(title),
            transient_for: this.get_root(),
            modal: true,
            action: params.action,
        });
        dialog.add_button('_Cancel', Gtk.ResponseType.CANCEL);
        dialog.add_button(acceptBtn, Gtk.ResponseType.ACCEPT);

        dialog.connect('response', (self, response) => {
            if (response === Gtk.ResponseType.ACCEPT) {
                try {
                    acceptHandler(dialog.get_file().get_path());
                } catch (e) {
                    log(`AppsIconTaskbar - Filechooser error: ${e}`);
                }
            }
            dialog.destroy();
        });

        dialog.show();
    }
});

var GNU_SOFTWARE = '<span size="small">' +
    'This program comes with absolutely no warranty.\n' +
    'See the <a href="https://gnu.org/licenses/old-licenses/gpl-2.0.html">' +
    'GNU General Public License, version 2 or later</a> for details.' +
    '</span>';
