local alpha = require("alpha")
local startify = require("alpha.themes.startify")
local fortune = require("alpha.fortune")()
-- local says = {
--   [[    o              ]],
--   [[     o     .--.    ]],
--   [[      o   |o_o |   ]],
--   [[          |:_/ |   ]],
--   [[         //   \ \  ]],
--   [[        (|     | ) ]],
--   [[       /'\_   _/`\ ]],
--   [[       \___)=(___/ ]],
-- }
local says = {
  [[                         ]],
  [[    o                    ]],
  [[     o   ^__^            ]],
  [[      o  (oo)\_______    ]],
  [[         (__)\       )\/\]],
  [[             ||----w |   ]],
  [[             ||     ||   ]],
}

for _, v in ipairs(says) do
  table.insert(fortune, v)
end

startify.section.header.val = fortune

alpha.setup(startify.config)
