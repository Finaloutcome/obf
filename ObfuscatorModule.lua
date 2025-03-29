local Obfuscator = {}
function Obfuscator.LuaObfuscate(script)
    if type(script) ~= "string" then
        return ""
    end
    local result = script
    result = result:gsub("%-%-%[%[.-%]%]", "")
    result = result:gsub("%-%-.-\n", "\n")
    result = result:gsub("%s+", " ")
    return result
end
function Obfuscator.XOREncode(str, key)
    if type(str) ~= "string" or type(key) ~= "number" then
        return ""
    end
    local encoded = {}
    for i = 1, #str do
        local byte = string.byte(str, i)
        local xored = bit32.bxor(byte, key)
        encoded[i] = string.char(xored)
    end
    return table.concat(encoded)
end
function Obfuscator.HexEncode(str)
    if type(str) ~= "string" then
        return ""
    end
    local hex = {}
    for i = 1, #str do
        local byte = string.byte(str, i)
        hex[i] = string.format("%02X", byte)
    end
    return table.concat(hex)
end
function Obfuscator.ASCIIEncode(str)
    if type(str) ~= "string" then
        return ""
    end
    local ascii = {}
    for i = 1, #str do
        ascii[i] = tostring(string.byte(str, i))
    end
    return table.concat(ascii, " ")
end
function Obfuscator.GCodeEncode(str)
    if type(str) ~= "string" then
        return ""
    end
    local gcode = {}
    for i = 1, #str do
        gcode[i] = "G" .. tostring(string.byte(str, i))
    end
    return table.concat(gcode, " ")
end
function Obfuscator.Obfuscate(script)
    if type(script) ~= "string" then
        error("脚本必须为字符串")
    end
    local step1 = Obfuscator.LuaObfuscate(script)
    local key = math.random(1, 255)
    local step2 = Obfuscator.XOREncode(step1, key)
    local step3 = Obfuscator.HexEncode(step2)
    local step4 = Obfuscator.ASCIIEncode(step3)
    local step5 = Obfuscator.GCodeEncode(step4)
    local final = "KEY:" .. key .. "\n" .. step5
    return final
end
return Obfuscator
