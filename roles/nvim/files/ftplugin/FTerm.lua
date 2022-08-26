local tmap = require("enoch.helpers").tmap
tmap([[<C-\><C-\>]], function()
    require("FTerm").toggle()
end)

