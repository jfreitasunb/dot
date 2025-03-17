const {Gio, GLib, Soup} = imports.gi;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const {debugLog, notify} = Me.imports.utils;

const Gettext = imports.gettext.domain(Me.metadata['gettext-domain']);
const _ = Gettext.gettext;

const STARTUP_DELAY = 3;
const TWELVE_HOURS_IN_SECONDS = 43200;
const TWELVE_HOURS_IN_MILLISECONDS = 4.32e7;
const SESSION_TYPE = GLib.getenv('XDG_SESSION_TYPE');
const PACKAGE_VERSION = imports.misc.config.PACKAGE_VERSION;

Gio._promisify(Soup.Session.prototype, 'send_and_read_async');
Gio._promisify(Gio.File.prototype, 'replace_contents_bytes_async', 'replace_contents_finish');

const BingParams = {
    format: 'js', idx: '0', n: '8', mbl: '1', mkt: 'en-US',
};

var BingWallpaperDownloader = class {
    constructor() {
        this._userAgent = `User-Agent: Mozilla/5.0 (${SESSION_TYPE}; GNOME Shell/${PACKAGE_VERSION}; Linux ${GLib.getenv('CPU')};) AzWallpaper/${Me.metadata.version}`;
    }

    initiate() {
        debugLog('Initiate BING Wallpaper downloader');

        this._bingWallpapersDirectory = Me.settings.get_string('bing-download-directory');

        if (!this._bingWallpapersDirectory) {
            this._setToDefaultDownloadDirectory();
            notify(_('No user defined directory found for BING wallpaper downloads'),
                _('Directory set to - %s').format(this._bingWallpapersDirectory));
        } else {
            const dir = Gio.File.new_for_path(this._bingWallpapersDirectory);
            if (!dir.query_exists(null)) {
                const success = dir.make_directory(null);
                if (!success) {
                    this._setToDefaultDownloadDirectory();
                    notify(_('Failed to create user defined directory for BING wallpaper downloads'),
                        _('Directory set to - %s').format(this._bingWallpapersDirectory));
                }
            }
        }

        if (this._session == null)
            this._session = new Soup.Session({user_agent: this._userAgent});

        this._startDownloaderTimer(this._getTimerDelay(), true);
    }

    _setToDefaultDownloadDirectory() {
        const pictureDirectory = GLib.get_user_special_dir(GLib.UserDirectory.DIRECTORY_PICTURES);
        this._bingWallpapersDirectory = GLib.build_filenamev([pictureDirectory, 'Bing Wallpapers']);
        Me.settings.set_string('bing-download-directory', this._bingWallpapersDirectory);

        const dir = Gio.File.new_for_path(this._bingWallpapersDirectory);
        if (!dir.query_exists(null))
            dir.make_directory(null);
    }

    _getPrettyTime(timespan) {
        const minutesAgo = timespan / 60;
        const hoursAgo = timespan / 3600;

        if (timespan <= 60)
            return `${timespan} seconds`;
        if (minutesAgo <= 60)
            return `${minutesAgo.toFixed(1)} minutes`;

        return `${hoursAgo.toFixed(1)} hours`;
    }

    _startDownloaderTimer(delay, runOnce) {
        this.endDownloaderTimer();

        debugLog(`BING Downloader - Next download attempt in ${this._getPrettyTime(delay)}`);
        this._fetchBingWallpaperId = GLib.timeout_add_seconds(GLib.PRIORITY_LOW, delay, () => {
            this._queueDownload().catch(e => debugLog(`BING Downloader - Error downloading: ${e}`));
            this._setLastDataFetch();
            if (runOnce) {
                // Set a 12 hour timer for next data fetch.
                this._startDownloaderTimer(TWELVE_HOURS_IN_SECONDS);
                return GLib.SOURCE_REMOVE;
            } else {
                return GLib.SOURCE_CONTINUE;
            }
        });
    }

    endDownloaderTimer() {
        if (this._fetchBingWallpaperId) {
            GLib.source_remove(this._fetchBingWallpaperId);
            this._fetchBingWallpaperId = null;
        }
    }

    async _queueDownload() {
        debugLog('BING Downloader - Starting download...');
        const {jsonData, error} = await this._getJsonData();

        if (!jsonData || error) {
            if (error)
                debugLog(`BING Downloader - ${error}`);
            else
                debugLog('BING Downloader - JSON data null');
            debugLog('BING Downloader - Download Failed!');
            return;
        }

        const results = [];
        for (const image of jsonData.images)
            results.push(this._downloadAndSaveImage(image));

        await Promise.all(results).then(values => {
            for (const value of values) {
                const {msg} = value;
                debugLog(msg);
            }
        });
        debugLog('BING Downloader - Download Finished!');
    }

    _getElapsedTime() {
        const lastDataFetch = Me.settings.get_uint64('bing-last-data-fetch');
        const dateNow = Date.now();

        const elapsedTime = dateNow - lastDataFetch;

        return elapsedTime;
    }

    _getTimerDelay() {
        const lastDataFetch = Me.settings.get_uint64('bing-last-data-fetch');
        const elapsedTime = this._getElapsedTime();
        const has12HoursPassed = elapsedTime >= TWELVE_HOURS_IN_MILLISECONDS;

        if (lastDataFetch === 0 || has12HoursPassed) {
            debugLog('BING Downloader - 12 hours passed. Queue download...');
            return STARTUP_DELAY;
        }

        const nextDataFetch = Math.floor((TWELVE_HOURS_IN_MILLISECONDS - elapsedTime) / 1000);
        return Math.max(nextDataFetch, STARTUP_DELAY);
    }

    _setLastDataFetch() {
        const dateNow = Date.now();
        Me.settings.set_uint64('bing-last-data-fetch', dateNow);
    }

    async _getJsonData() {
        const message = Soup.Message.new_from_encoded_form(
            'GET',
            'https://www.bing.com/HPImageArchive.aspx',
            Soup.form_encode_hash(BingParams)
        );
        message.request_headers.append('Accept', 'application/json');

        let info;
        try {
            const bytes = await this._session.send_and_read_async(message, GLib.PRIORITY_DEFAULT, null);

            const decoder = new TextDecoder('utf-8');
            info = JSON.parse(decoder.decode(bytes.get_data()));
            if (message.statusCode === Soup.Status.OK)
                return {jsonData: info};
            else
                return {error: `getJsonData() failed with status code - ${message.statusCode}`};
        } catch (e) {
            return {error: `getJsonData() error - ${e}`};
        }
    }

    async _downloadAndSaveImage(data) {
        const urlBase = data.urlbase;
        const url = `https://bing.com${urlBase}_UHD.jpg`;
        const startDate = data.startdate;
        const fileName = `${startDate}-${urlBase.replace(/^.*[\\/]/, '').replace('th?id=OHR.', '')}_UHD`;

        const filePath = GLib.build_filenamev([this._bingWallpapersDirectory, `${fileName}.jpg`]);
        const file = Gio.file_new_for_path(filePath);

        if (file.query_exists(null))
            return {msg: `BING Downloader - "${fileName}" already downloaded!`};

        debugLog(`BING Downloader - Retrieving "${fileName}" from BING`);

        const message = Soup.Message.new('GET', url);

        let info;
        try {
            const bytes = await this._session.send_and_read_async(message, GLib.PRIORITY_DEFAULT, null);

            if (message.statusCode === Soup.Status.OK) {
                info = bytes.get_data();
                const [success] = await file.replace_contents_bytes_async(info, null, false,
                    Gio.FileCreateFlags.REPLACE_DESTINATION, null);
                if (success)
                    return {msg: 'BING Downloader - Image download complete!'};
                else
                    return {msg: 'BING Downloader - Error saving file!"'};
            } else {
                return {msg: `BING Downloader - Image download failed with status code - ${message.statusCode}`};
            }
        } catch (e) {
            return {msg: `BING Downloader - Image download failed - ${e}`};
        }
    }
};
