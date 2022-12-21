return {
    "goolord/alpha-nvim",
    config = function()
        local alpha = require "alpha"
        local startify = require "alpha.themes.startify"
        local fortune = require "alpha.fortune"

        -- ---@param message table
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

        -- ---@param message table
        -- local function tuxsays(message)
        --     local says = {
        --         "    o              ",
        --         "     o     .--.    ",
        --         "      o   |o_o |   ",
        --         "          |:_/ |   ",
        --         "         //   \\ \\  ",
        --         "        (|     | ) ",
        --         "       /'\\_   _/`\\ ",
        --         "       \\___)=(___/ ",
        --     }

        --     for _, str in ipairs(says) do
        --         table.insert(message, str)
        --     end

        --     return message
        -- end

        startify.section.header.val = cowsays(fortune())
        alpha.setup(startify.config)
    end,
}
