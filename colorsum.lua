#!/usr/bin/env lua

--[[
    inspired by
    https://rosettacode.org/wiki/Checksumcolor
]]

function lerp(a, b, v)
    return a + (b - a) * v
end

local cprint = (function()
    local c = {}
    for i=31,37 do table.insert(c,i) end
    local fmt = '\27[%sm%s\27[0m'
    return function(line)
        local ok, _,sum = line:find("(.+)%s.+")
        if not ok then print(line) return end
        local idx = 1
        for n in sum:gmatch("%x%x%x") do
            local num = tonumber("0x"..n)
            io.write(fmt:format(
                c[math.floor(lerp(1,#c,num/4096) + 0.5)],
                n
            ))
            idx = idx + 3
        end
        io.write(string.format("%s\n", line:sub(idx)))
    end
end)()

local function isTTY(fd)
    fd = tonumber(fd) or 1
    local ok, exit, signal = os.execute(string.format("test -t %d", fd))
    return (ok and exit == "exit") and signal == 0 or false
end

local printfn
if not isTTY() then
    printfn = print
else
    printfn = cprint
end

for line in io.stdin:lines() do
    printfn(line)
end
