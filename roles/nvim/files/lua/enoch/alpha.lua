local alpha = require "alpha"
local startify = require "alpha.themes.startify"
-- local get_fortune = require "alpha.fortune"
local quotes = require "enoch.quotes"

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

math.randomseed(os.time())
local rand = math.random(1,#quotes)
local msg = {} -- get_fortune()
for _, str in ipairs(quotes[rand]) do
    for _, sstr in ipairs(vim.fn.split(str, "\n")) do
        table.insert(msg, sstr)
    end
end
startify.section.header.val = cowsays(msg)
alpha.setup(startify.config)
