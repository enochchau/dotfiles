local alpha = require "alpha"
local startify = require "alpha.themes.startify"

local quotes_filename = vim.fn.expand "~/.config/nvim/lua/enoch/quotes.json"
local quotes = vim.fn.json_decode(vim.fn.readfile(quotes_filename))

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
local rand = math.random(1, #quotes)
local msg = {}
local q = quotes[rand]
for _, str in ipairs(vim.fn.split(q.quote, "\n")) do
    table.insert(msg, str)
end
table.insert(msg, "- " .. q.author)
startify.section.header.val = cowsays(msg)
alpha.setup(startify.config)
