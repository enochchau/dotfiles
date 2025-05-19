local replace_all = require("enoch.pretty-ts-errors.utils").replace_all

---@param code string
---@param language string
local function inline_code_block(code, language)
    return string.format("```%s\n%s\n```\n", language, code)
end

---@param content string
local function unstyled_code_block(content)
    return "`" .. content .. "`"
end

---@param prefix string
---@param type string
local function format_type_block(prefix, type)
    if vim.regex([[^\(\[\]|\{\}\)$]]):match_str(type) then
        return string.format("%s %s", prefix, unstyled_code_block(type))
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

---@param message string
---@return string
local function format_diagnostic_message(message)
    message = replace_all(
        message,
        [[\(?:\s\)'"\(.*?\)\(?<!\\\)"'\(?:\s|:|.|$\)]],
        function(match_info)
            local p1 = match_info[2]
            return format_type_block("", p1)
        end
    )

    -- format declare module snippet
    message = replace_all(
        message,
        [=[['“]\(declare module \)['”]\(.*\)['“];['”]]=],
        function(m)
            local _ = m[1]
            local p1 = m[2]
            local p2 = m[3]
            return format_typescript_block(
                _,
                string.format('`%s "%s"`', p1, p2)
            )
        end
    )

    return message
end

return {
    format_diagnostic_message = format_diagnostic_message,
}
