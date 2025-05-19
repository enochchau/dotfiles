/**
 * Converts a JavaScript regular expression (string or RegExp object)
 * into a Vim regular expression string.
 * Handles common syntax differences for grouping, anchors, and quantifiers.
 * Does NOT handle advanced features like lookarounds, named capture groups, or flags.
 *
 * @param {string | RegExp} jsRegex The JavaScript regex, either as a string or a RegExp object.
 * @returns {string} The equivalent Vim regular expression string.
 */
function jsRegexToVimRegex(jsRegex) {
  // Get the regex pattern string from the input
  let jsRegexString;
  if (jsRegex instanceof RegExp) {
    jsRegexString = jsRegex.source;
    // Note: Flags like 'g', 'i', 'm' are not handled by this conversion function.
    // You would need to handle those separately in your Vim command or settings.
  } else if (typeof jsRegex === "string") {
    jsRegexString = jsRegex;
  } else {
    console.error(
      "Invalid input: Parameter must be a string or RegExp object."
    );
    return ""; // Return empty string or throw an error for invalid input
  }

  let vimRegex = "";
  let i = 0;
  const n = jsRegexString.length;
  let inCharacterClass = false; // State to track if we are inside []

  while (i < n) {
    const char = jsRegexString[i];

    if (char === "\\") {
      // Handle escaped characters. Assume most common escapes are the same.
      // We need to be careful about escaping characters that have special meaning
      // in Vim regex but might be escaped in JS for other reasons.
      // For simplicity, we pass through the escape sequence directly.
      if (i + 1 < n) {
        vimRegex += char + jsRegexString[i + 1];
        i += 2;
      } else {
        // Trailing backslash - likely invalid JS regex, but handle defensively
        vimRegex += char;
        i += 1;
      }
    } else if (char === "[") {
      // Start of a character class
      vimRegex += char;
      inCharacterClass = true;
      i += 1;
    } else if (char === "]") {
      // End of a character class
      vimRegex += char;
      inCharacterClass = false;
      i += 1;
    } else if (!inCharacterClass) {
      // Handle special characters OUTSIDE character classes
      if (char === "(") {
        // Check for non-capturing group (?:...)
        if (
          i + 2 < n &&
          jsRegexString[i + 1] === "?" &&
          jsRegexString[i + 2] === ":"
        ) {
          // (?:...) becomes \%(...\)
          vimRegex += "\\%(";
          i += 3;
        } else {
          // Capturing group (...) becomes \(...\)
          vimRegex += "\\(";
          i += 1;
        }
      } else if (char === ")") {
        // Closing parenthesis becomes \)
        vimRegex += "\\)";
        i += 1;
      } else if (char === "^" && i === 0) {
        // Start anchor at the beginning of the string becomes \%^
        // (Only if it's the very first character and not escaped,
        // escaped ^ is handled by the '\\' case)
        vimRegex += "\\%^";
        i += 1;
      } else if (char === "$" && i === n - 1) {
        // End anchor at the end of the string becomes \%$
        // (Only if it's the very last character and not escaped,
        // escaped $ is handled by the '\\' case)
        vimRegex += "\\%$";
        i += 1;
      } else if (char === "+") {
        // Quantifier +
        if (i + 1 < n && jsRegexString[i + 1] === "?") {
          // Non-greedy +? becomes \+?
          vimRegex += "\\+?";
          i += 2;
        } else {
          // Greedy + becomes \+
          vimRegex += "\\+";
          i += 1;
        }
      } else if (char === "*") {
        // Quantifier *
        if (i + 1 < n && jsRegexString[i + 1] === "?") {
          // Non-greedy *? becomes \*?
          vimRegex += "\\*?";
          i += 2;
        } else {
          // Greedy * becomes \*
          vimRegex += "\\*";
          i += 1;
        }
      } else if (char === "?") {
        // Quantifier ?
        if (i + 1 < n && jsRegexString[i + 1] === "?") {
          // Non-greedy ?? becomes \??
          vimRegex += "\\??";
          i += 2;
        } else {
          // Greedy ? becomes \?
          vimRegex += "\\?";
          i += 1;
        }
      } else {
        // Default: add the character as is
        vimRegex += char;
        i += 1;
      }
    } else {
      // Inside character class [], add character as is.
      // Special characters like ^, -, ] are handled correctly by Vim inside [].
      vimRegex += char;
      i += 1;
    }
  }

  return vimRegex;
}

[
  /(?:\s)'"(.*?)(?<!\\)"'(?:\s|:|.|$)/,
  /['“](declare module )['”](.*)['“];['”]/,
  /(is missing the following properties from type\s?)'(.*)': ((?:#?\w+, )*(?:(?!and)\w+)?)/,
  /(types) ['“](.*?)['”] and ['“](.*?)['”][.]?/,
  /type annotation must be ['“](.*?)['”] or ['“](.*?)['”][.]?/,
  /(Overload \d of \d), ['“](.*?)['”], /,
  /^['“]"[^"]*"['”]$/,
  /(module )'([^"]*?)'/,
  /(module|file|file name|imported via) ['"“](.*?)['"“](?=[\s(.|,]|$)/,
  /(type|type alias|interface|module|file|file name|class|method's|subtype of constraint) ['“](.*?)['“](?=[\s(.|,)]|$)/,
  /(.*)['“]([^>]*)['”] (type|interface|return type|file|module|is (not )?assignable)/,
  /['“]((void|null|undefined|any|boolean|string|number|bigint|symbol)(\[\])?)['”]/,
  /['“](import|export|require|in|continue|break|let|false|true|const|new|throw|await|for await|[0-9]+)( ?.*?)['”]/,
  /(return|operator) ['“](.*?)['”]/,
  /(?<!\w)'((?:(?!["]).)*?)'(?!\w)/,
].forEach((re) => console.log("[=[" + jsRegexToVimRegex(re) + "]=]"));

// // Example Usage:
// const jsRegexString1 = "^\\d+$";
// const vimRegex1 = jsRegexToVimRegex(jsRegexString1);
// console.log(`JS String: "${jsRegexString1}" -> Vim: "${vimRegex1}"`);
//
// const jsRegexObject1 = /^\d+$/;
// const vimRegexObject1 = jsRegexToVimRegex(jsRegexObject1);
// console.log(`JS RegExp: ${jsRegexObject1} -> Vim: "${vimRegexObject1}"`); // Expected: JS RegExp: /^\d+$/ -> Vim: "\%^\d\+$"
//
//
// const jsRegexString2 = "a(?:b|c)*?d";
// const vimRegex2 = jsRegexToVimRegex(jsRegexString2);
// console.log(`JS String: "${jsRegexString2}" -> Vim: "${vimRegex2}"`);
//
// const jsRegexObject2 = /a(?:b|c)*?d/;
// const vimRegexObject2 = jsRegexToVimRegex(jsRegexObject2);
// console.log(`JS RegExp: ${jsRegexObject2} -> Vim: "${vimRegexObject2}"`); // Expected: JS RegExp: /a(?:b|c)*?d/ -> Vim: "a\%(b|c\)\*?d"
//
//
// const jsRegexString3 = "[a-zA-Z0-9_]+";
// const vimRegex3 = jsRegexToVimRegex(jsRegexString3);
// console.log(`JS String: "${jsRegexString3}" -> Vim: "${vimRegex3}"`);
//
// const jsRegexObject3 = /[a-zA-Z0-9_]+/;
// const vimRegexObject3 = jsRegexToVimRegex(jsRegexObject3);
// console.log(`JS RegExp: ${jsRegexObject3} -> Vim: "${vimRegexObject3}"`); // Expected: JS RegExp: /[a-zA-Z0-9_]+/ -> Vim: "[a-zA-Z0-9_]\+"
//
//
// const jsRegexString4 = "hello\\(world\\)"; // Matches "hello(world)" literally
// const vimRegex4 = jsRegexToVimRegex(jsRegexString4);
// console.log(`JS String: "${jsRegexString4}" -> Vim: "${vimRegex4}"`);
//
// const jsRegexObject4 = /hello\(world\)/; // Matches "hello(world)" literally
// const vimRegexObject4 = jsRegexToVimRegex(jsRegexObject4);
// console.log(`JS RegExp: ${jsRegexObject4} -> Vim: "${vimRegexObject4}"`); // Expected: JS RegExp: /hello\(world\)/ -> Vim: "hello\\(world\\)"
//
// // Example with invalid input
// // const invalidInput = 123;
// // const vimRegexInvalid = jsRegexToVimRegex(invalidInput);
// // console.log(`Invalid Input: ${invalidInput} -> Vim: "${vimRegexInvalid}"`);
//
//
