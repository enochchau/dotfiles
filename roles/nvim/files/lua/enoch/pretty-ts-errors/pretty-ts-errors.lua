local replace_all = require("enoch.pretty-ts-errors.utils").replace_all

---@param code string
---@param language string
local function inline_code_block(code, language)
    return string.format("```%s\n%s\n```\n", language, code)
end

---@param content string
local function un_styled_code_block(content)
    return "```\n" .. content .. "\n```\n"
end

---@param prefix string
---@param type string
local function format_type_block(prefix, type)
    if vim.regex([[^\(\[\]|\{\}\)$]]):match_str(type) then
        return string.format("%s %s", prefix, un_styled_code_block(type))
    end

    if
        vim.regex(
            [[^\(\(void|null|undefined|any|number|string|bigint|symbol|readonly|typeof\)\(\[\]\)?\)$]]
        ):match_str(type)
    then
        return string.format("%s %s", prefix, inline_code_block(type, "type"))
    end

    -- TODO: prettifyType
    --
    return inline_code_block(type, "type")
end

---@param _ string
---@param code string
local function format_typescript_block(_, code)
    return inline_code_block(code, "typescript")
end

---@param _ string
---@param code string
local function format_simple_type_block(_, code)
    return inline_code_block(code, "type")
end
---@param message string
---@return string
local function format_diagnostic_message(message)
    -- format quoted strings
    message = replace_all(
        message,
[=[\%(\s\)'"\(.\*?\)\(\?<!\\\)"'\%(\s|:|.|$\)]=],
        function(match_info)
            local p1 = match_info[2]
            -- Ignoring the 'format' function call as requested
            return format_type_block("", '"' .. p1 .. '"')
        end
    )

    -- format declare module snippet
    message = replace_all(
        message,
[=[['“]\(declare module \)['”]\(.\*\)['“];['”]]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            return format_typescript_block(
                "", -- The original JS uses the full match here, which is the whole string being replaced. We'll pass an empty string if formatTypeScriptBlock doesn't need it. Adjust if the Lua function requires the full match.
                string.format('%s "%s"', p1, p2)
            )
        end
    )

    -- format missing props error
    message = replace_all(
        message,
[=[\(is missing the following properties from type\s\?\)'\(.\*\)': \(\%(#\?\w\+, \)\*\%(\(\?!and\)\w\+\)\?\)]=],
        function(m)
            local pre = m[2]
            local type_str = m[3]
            local post = m[4]
            local formatted_type = format_type_block("", type_str) -- Ignoring the 'format' function call
            local props_list = {}
            -- Split by ", " and filter out empty strings
            for prop in string.gmatch(post .. ",", "([^,]-),%s*") do
                if string.match(prop, "%S") then -- Check if not just whitespace
                    table.insert(props_list, "<li>" .. prop .. "</li>")
                end
            end

            return pre
                .. formatted_type
                .. ": <ul>"
                .. table.concat(props_list, "")
                .. "</ul>"
        end
    )

    -- Format type pairs
    message = replace_all(
        message,

[=[\(types\) ['“]\(.\*?\)['”] and ['“]\(.\*?\)['”][.]\?]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            local p3 = m[4]
            -- Ignoring the 'format' function calls
            return format_type_block(p1, p2)
                .. " and "
                .. format_type_block("", p3)
        end
    )

    -- Format type annotation options
    message = replace_all(
        message,
[=[type annotation must be ['“]\(.\*?\)['”] or ['“]\(.\*?\)['”][.]\?]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            -- Ignoring the 'format' function calls
            return format_type_block("", p1)
                .. " or "
                .. format_type_block("", p2)
        end
    )

    message = replace_all(
        message,
[=[\(Overload \d of \d\), ['“]\(.\*?\)['”], ]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            -- Ignoring the 'format' function call
            return p1 .. format_type_block("", p2)
        end
    )

    -- format simple strings
    message =
        replace_all(message, 

[=[\%^['“]"[^"]\*"['”]\%$]=]
        , format_typescript_block) -- Assuming format_typescript_block can handle the match directly

    -- Replace module 'x' by module "x" for ts error #2307
    message = replace_all(message, 

[=[\(module \)'\([^"]\*?\)']=]
    , function(m)
        local p1 = m[2]
        local p2 = m[3]
        return p1 .. '"' .. p2 .. '"'
    end)

    -- Format string types
    message = replace_all(
        message,
[=[\(module|file|file name|imported via\) ['"“]\(.\*?\)['"“]\(\?=[\s(.|,]|$\)]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            -- Ignoring the 'format' function call
            return format_type_block(p1, '"' .. p2 .. '"')
        end
    )

    -- Format types
    message = replace_all(
        message,

[=[\(type|type alias|interface|module|file|file name|class|method's|subtype of constraint\) ['“]\(.\*?\)['“]\(\?=[\s(.|,)]|$\)]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            -- Ignoring the 'format' function call
            return format_type_block(p1, p2)
        end
    )

    -- Format reversed types
    message = replace_all(
        message,

[=[\(.\*\)['“]\([^>]\*\)['”] \(type|interface|return type|file|module|is \(not \)\?assignable\)]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            local p3 = m[4]
            -- Ignoring the 'format' function call
            return p1 .. format_type_block("", p2) .. " " .. p3
        end
    )

    -- Format simple types that didn't captured before
    message = replace_all(
        message,
[=[['“]\(\(void|null|undefined|any|boolean|string|number|bigint|symbol\)\(\[\]\)\?\)['”]]=],
        format_simple_type_block -- Assuming the Lua function exists and handles the match
    )

    -- Format some typescript key words
    message = replace_all(
        message,

[=[['“]\(import|export|require|in|continue|break|let|false|true|const|new|throw|await|for await|[0-9]\+\)\( \?.\*?\)['”]]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            return format_typescript_block("", p1 .. p2) -- Assuming formatTypeScriptBlock needs the parts concatenated
        end
    )

    -- Format return values
    message = replace_all(
        message,
[=[\(return|operator\) ['“]\(.\*?\)['”]]=],
        function(m)
            local p1 = m[2]
            local p2 = m[3]
            return p1 .. " " .. format_typescript_block("", p2) -- Assuming formatTypeScriptBlock
        end
    )

    -- Format regular code blocks
    message = replace_all(
        message,
        [=[\(\w\)\@<!'\(\%(\(\?!["]\).\)\*?\)'\(\?!\w\)]=],
        function(m)
            local p1 = m[2]
            return " " .. un_styled_code_block(p1) .. " " -- Assuming unStyledCodeBlock exists and is snake_case in Lua
        end
    )

    return message
end

return {
    format_diagnostic_message = format_diagnostic_message,
}
