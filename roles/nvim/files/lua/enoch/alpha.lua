local alpha = require("alpha")
local startify = require("alpha.themes.startify")
local fortune = require("alpha.fortune")()
local cowsays = {
  [[    \   ^__^            ]],
  [[     \  (oo)\_______    ]],
  [[        (__)\       )\/\]],
  [[            ||----w |   ]],
  [[            ||     ||   ]],
}

for _, v in ipairs(cowsays) do
  table.insert(fortune, v)
end

startify.section.header.val = fortune

alpha.setup(startify.config)
