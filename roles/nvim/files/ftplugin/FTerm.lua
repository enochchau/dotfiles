local tmap = require("enoch.helpers").tmap
tmap([[<C-\>]], function()
    require("FTerm").toggle()
end)

