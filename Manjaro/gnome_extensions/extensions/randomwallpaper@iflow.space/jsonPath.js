import * as Utils from './utils.js';


/**
 * Access a simple json path expression of an object.
 * Returns the accessed value or null if the access was not possible.
 * Accepts predefined number values to access the same elements as previously
 * and allows to override the use of these values.
 *
 * @param {unknown} inputObject A JSON object
 * @param {string} inputString JSONPath to follow, see wiki for syntax
 * @returns {[unknown, string]} Tuple with an object of unknown type and a chosen JSONPath string
 */
function getTarget(inputObject, inputString) {
    if (!inputObject)
        return [null, ''];

    if (inputString.length === 0)
        return [inputObject, inputString];

    let startDot = inputString.indexOf('.');

    if (startDot === -1)
        startDot = inputString.length;

    let keyString = inputString.slice(0, startDot);

    const inputStringTail = inputString.slice(startDot + 1);
    const startParentheses = keyString.indexOf('[');

    if (startParentheses === -1) {
        // Expect Object here
        const targetObject = _getObjectMember(inputObject, keyString);

        if (!targetObject)
            return [null, ''];

        const [object, path] = getTarget(targetObject, inputStringTail);

        return [object, inputString.slice(0, inputString.length - inputStringTail.length) + path];
    } else {
        const indexString = keyString.slice(startParentheses + 1, keyString.length - 1);
        keyString = keyString.slice(0, startParentheses);

        // Expect an Array at this point
        const targetObject = _getObjectMember(inputObject, keyString);

        if (!targetObject || !Array.isArray(targetObject))
            return [null, ''];


        // add special keywords here
        switch (indexString) {
        case '@random': {
            const [chosenElement, chosenNumber] = _randomElement(targetObject);
            const [object, path] = getTarget(chosenElement, inputStringTail);

            return [object, inputString.slice(0, inputString.length - inputStringTail.length).replace('@random', String(chosenNumber)) + path];
        }
        default: {
            // expecting integer
            const [object, path] = getTarget(targetObject[parseInt(indexString)], inputStringTail);

            return [object, inputString.slice(0, inputString.length - inputStringTail.length) + path];
        }
        }
    }
}

/**
 * Check validity of the key string and return the target member or null.
 *
 * @param {object} inputObject JSON object
 * @param {string} keyString Name of the key in the object
 * @returns {unknown | null} Found object member or null
 */
function _getObjectMember(inputObject, keyString) {
    if (keyString === '$')
        return inputObject;

    for (const [key, value] of Object.entries(inputObject)) {
        if (key === keyString)
            return value;
    }

    return null;
}

/**
 * Returns the value of a random key of a given array.
 *
 * @param {Array<T>} array Array with values
 * @returns {[T, number]} Tuple with an array member and index of that member
 */
function _randomElement(array) {
    const randomNumber = Utils.getRandomNumber(array.length);

    return [array[randomNumber], randomNumber];
}

/**
 * Replace '@random' according to an already resolved path.
 *
 * '@random' would yield different results so this makes sure the values stay
 * the same as long as the path is identical.
 *
 * @param {string} randomPath Path containing '@random' to resolve
 * @param {string} resolvedPath Path with resolved '@random'
 * @returns {string} Input string with replaced '@random'
 */
function replaceRandomInPath(randomPath, resolvedPath) {
    if (!randomPath.includes('@random'))
        return randomPath;

    let newPath = randomPath;

    while (newPath.includes('@random')) {
        const startRandom = newPath.indexOf('@random');


        // abort if path is not equal up to this point
        if (newPath.substring(0, startRandom) !== resolvedPath.substring(0, startRandom))
            break;

        const endParenthesis = resolvedPath.indexOf(']', startRandom);
        newPath = newPath.replace('@random', resolvedPath.substring(startRandom, endParenthesis));
    }

    return newPath;
}

export {getTarget, replaceRandomInPath};
