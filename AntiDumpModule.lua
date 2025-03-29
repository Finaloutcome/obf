local AntiDump = {}

function AntiDump.Protect()
    pcall(function() _G.print = function(...) end end)
    pcall(function() _G.warn  = function(...) end end)
    pcall(function() _G.error = function(...) end end)
    for key, value in pairs(_G) do
        if type(value) == "function" and string.find(string.lower(tostring(key)), "dump") then
            pcall(function() _G[key] = function(...) end end)
        end
    end
    if debug then
        pcall(function() debug.sethook(function() end) end)
        pcall(function() debug.getinfo = function(...) return {} end) end)
        pcall(function() debug.traceback = function(...) return "" end) end)
        pcall(function() debug.getlocal = function(...) return nil end) end)
        pcall(function() debug.getupvalue = function(...) return nil end) end)
        pcall(function() debug.setmetatable = function(...) return end end)
        pcall(function() debug.getmetatable = function(...) return {} end) end)
    end
    pcall(function()
        local mt = getmetatable(_G) or {}
        mt.__metatable = "Access Denied"
        setmetatable(_G, mt)
    end)
    if getfenv then
        pcall(function() getfenv = function(...) return {} end end)
    end
    if setfenv then
        pcall(function() setfenv = function(...) return end end)
    end
    return true
end

return AntiDump
