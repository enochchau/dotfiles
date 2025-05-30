local uv = vim.uv
local server

local function start()
    if server ~= nil then
        pcall(uv.close, server)
    end
    server = uv.new_tcp()
    server:bind("127.0.0.1", 6846)
    vim.ui.open("http://127.0.0.1:6846")
    server:listen(128, function(err)
        assert(not err, err)

        local client = uv.new_tcp()
        server:accept(client)
        client:read_start(function(err, chunk)
            assert(not err, err)
            if chunk then
                local lines = vim.split(chunk, "\n")
                local method, path, version
                for i, line in ipairs(lines) do
                    if i == 1 then
                        local pattern = "(%u+)%s+(%S+)%s+HTTP/(%d+%.%d+)"

                        method, path, version = string.match(line, pattern)
                    end
                end

                local response = {}
                if path == "/" then
                    response = {
                        "HTTP/1.1 200 OK",
                        "Server: Neovim",
                        "Date: " .. os.date("!%a, %d %b %Y %H:%M:%S GMT"),
                        "Content-Type: text/plain",
                        "Cache-Control: no-store",
                        "",
                        "hello world",
                    }
                else
                    response = {
                        "HTTP/1.1 400 Bad Request",
                        "Server: Neovim",
                        "Date: " .. os.date("!%a, %d %b %Y %H:%M:%S GMT"),
                        "Cache-Control: no-store",
                    }
                end

                client:write(vim.iter(lines):join("\n"))
                client:shutdown()
            else
                client:close()
            end
        end)
    end)
    uv.run()
end

local function stop()
    if server ~= nil then
        server:close()
    end
end

return {
    start = start,
    stop = stop,
}
