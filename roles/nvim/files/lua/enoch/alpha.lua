local alpha = require "alpha"
local startify = require "alpha.themes.startify"
local get_fortune = require "alpha.fortune"

---@param message table
local function cowsays(message)
    local says = {
        "                         ",
        "    o                    ",
        "     o   ^__^            ",
        "      o  (oo)\\_______    ",
        "         (__)\\       )\\/\\",
        "             ||----w |   ",
        "             ||     ||   ",
    }

    for _, str in ipairs(says) do
        table.insert(message, str)
    end

    return message
end

---@param message table
local function tuxsays(message)
    local says = {
        "    o              ",
        "     o     .--.    ",
        "      o   |o_o |   ",
        "          |:_/ |   ",
        "         //   \\ \\  ",
        "        (|     | ) ",
        "       /'\\_   _/`\\ ",
        "       \\___)=(___/ ",
    }

    for _, str in ipairs(says) do
        table.insert(message, str)
    end

    return message
end

startify.section.header.val = cowsays(get_fortune())
alpha.setup(startify.config)
