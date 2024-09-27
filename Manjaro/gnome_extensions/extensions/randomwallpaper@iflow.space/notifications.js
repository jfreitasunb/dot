import {notify} from 'resource:///org/gnome/shell/ui/main.js';

/**
 * A convenience class for presenting notifications to the user.
 */
class Notification {
    /**
     * Show a notification for the newly set wallpapers.
     *
     * @param {HistoryEntry[]} historyEntries The history elements representing the new wallpapers
     */
    static newWallpaper(historyEntries) {
        const infoString = `Source: ${historyEntries.map(h => `${h.source.source ?? 'Unknown Source'}`).join(', ')}`;
        const message = `A new wallpaper was set!\n${infoString}`;
        notify('New Wallpaper', message);
    }

    /**
     * Show an error notification for failed wallpaper downloads.
     *
     * @param {unknown} error The error that was thrown when fetching a new wallpaper
     */
    static fetchWallpaperFailed(error) {
        let errorMessage = String(error);

        if (error instanceof Error)
            errorMessage = error.message;

        notify('RandomWallpaperGnome3: Wallpaper Download Failed!', errorMessage);
    }
}

export {Notification};
