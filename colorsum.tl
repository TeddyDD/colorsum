--[[
    inspired by
    https://rosettacode.org/wiki/Checksumcolor
]]

local type printFunction = function(string)

local function lerp(a:number, b:number, v:number): number
    return a + (b - a) * v
end

local function cprint(): printFunction
    local c: {string} = {}
    for i=31,37 do table.insert(c,i) end
    local fmt = '\27[%sm%s\27[0m'
    return function(line:string)
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
end

local function isTTY(fd: number): boolean
    fd = tonumber(fd) or 1
    local ok, exit, signal = os.execute(string.format("test -t %d", fd))
    return (ok and exit == "exit") and signal == 0 or false
end

local printfn: printFunction
if not isTTY() then
    printfn = print as printFunction -- safe cast from function(any)
else
    printfn = cprint()
end

for line in io.stdin:lines() do
    printfn(line)
end
