import Soup from 'gi://Soup';
import {Logger} from './logger.js';

/**
 * A compatibility and convenience wrapper around the Soup API.
 *
 * libSoup is accessed through the SoupBowl wrapper to support libSoup3 and libSoup2.4 simultaneously in the extension
 * runtime and in the preferences window.
 */
class SoupBowl {
    constructor() {
        this.MessageFlags = Soup.MessageFlags;
        this._session = new Soup.Session();
    }

    /**
     * Send a request with Soup.
     *
     * @param {Soup.Message} soupMessage Message to send
     * @returns {Promise<Uint8Array>} Raw byte answer
     */
    send_and_receive(soupMessage) {
        if (Soup.get_major_version() === 2)
            return this._send_and_receive_soup24(soupMessage);
        else if (Soup.get_major_version() === 3)
            return this._send_and_receive_soup30(soupMessage);
        else
            throw new Error('Unknown libsoup version');
    }

    /**
     * Craft a new GET request.
     *
     * @param {string} uri Request address
     * @returns {Soup.Message} Crafted message
     */
    newGetMessage(uri) {
        const message = Soup.Message.new('GET', uri);

        // set User-Agent to appear more like a standard browser
        message.request_headers.append('User-Agent', 'RandomWallpaperGnome3/3.0');

        return message;
    }

    /**
     * Send a request using Soup 2.4
     *
     * @param {Soup.Message} soupMessage Request message
     * @returns {Promise<Uint8Array>} Raw byte answer
     */
    _send_and_receive_soup24(soupMessage) {
        return new Promise((resolve, reject) => {
            try {
                /* eslint-disable */
                // Incompatible version of Soup types. Ignoring type checks.
                // @ts-ignore
                this._session.queue_message(soupMessage, (_, msg) => {
                    if (!msg.response_body) {
                        reject(new Error('Message has no response body'));
                        return;
                    }
                    const response_body_bytes = msg.response_body.flatten().get_data();
                    resolve(response_body_bytes);
                });
                /* eslint-enable */
            } catch (error) {
                Logger.error(error, this);
                reject(new Error('Request failed'));
            }
        });
    }

    /**
     * Send a request using Soup 3.0
     *
     * @param {Soup.Message} soupMessage Request message
     * @returns {Promise<Uint8Array>} Raw byte answer
     */
    _send_and_receive_soup30(soupMessage) {
        return new Promise((resolve, reject) => {
            this._session.send_and_read_async(soupMessage, 1, null).then(bytes => {
                if (bytes)
                    resolve(bytes.toArray());
                else
                    reject(new Error('Empty response'));
            }).catch(error => {
                Logger.error(error, this);
                reject(new Error('Request failed'));
            });
        });
    }
}

export {SoupBowl};
