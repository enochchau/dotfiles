--- Replaces all occurrences of a Vim regex pattern in a string.
--- @param text string The input string.
--- @param pattern string The Vim regex pattern to search for.
--- @param replacement string|fun(match_table: table): string The replacement string or a function
---   that takes the match information table and returns the replacement string.
--- @return string The string with replacements made.
local function replace_all(text, pattern, replacement)
    local matches = vim.fn.matchlist(text, pattern)

    while #matches > 0 do
        matches = vim.tbl_filter(function(value)
            return string.len(value) > 0
        end, matches)

        if type(replacement) == "function" then
            replacement = replacement(matches)
        end

        text = text:gsub(matches[1], replacement)
        matches = vim.fn.matchlist(text, pattern)
    end

    return text
end

return {
    replace_all = replace_all,
}
