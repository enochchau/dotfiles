local function json_read(filename)
    local f = vim.fn.expand(filename)
    return vim.fn.json_decode(vim.fn.readfile(f))
end
local function rand_quote()
    math.randomseed(os.time())
    local quotes = json_read "~/.config/nvim/quotes.json"
    local rand = math.random(1, #quotes)
    local q = quotes[rand]
    local msg = {}
    local split_80
    local function _1_(str)
        table.insert(msg, string.sub(str, 1, 80))
        return table.insert(msg, vim.trim(string.sub(str, 81)))
    end
    split_80 = _1_
    for _, str in ipairs(vim.fn.split(q.quote, "\n")) do
        if #str > 80 then
            split_80(str)
        else
            table.insert(msg, str)
        end
    end
    table.insert(msg, ("- " .. q.author))
    return msg
end
return { ["rand-quote"] = rand_quote }
