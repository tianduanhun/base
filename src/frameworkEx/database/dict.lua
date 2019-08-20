local g_Dict = {}

local UserDefault = cc.UserDefault:getInstance()
local path = device.writablePath .. "files/dict/"

function g_Dict.load(name)
    assert(name and type(name) == "string", "save key is not string")
    local str = UserDefault:getStringForKey(name)
    str = crypto.decodeBase64(str)
    return json.decode(str)
end

function g_Dict.save(name, data)
    assert(name and type(name) == "string", "save key is not string")
    local str = json.encode(data)
    str = crypto.encodeBase64(str)
    UserDefault:setStringForKey(name, str)
end

function g_Dict.loadFile(fileName)
    g_FileUtils.checkDir(path)
    if g_FileUtils.isFileExist(path .. fileName) then
        local str = g_FileUtils.getFileContent(path .. fileName)
        str = crypto.decodeBase64(str)
        return json.decode(str)
    end
end

function g_Dict.saveFile(fileName, data)
    g_FileUtils.checkDir(path)
    local str = json.encode(data)
    str = crypto.encodeBase64(str)
    g_FileUtils.writeDataToFile(path .. fileName, str)
end

return g_Dict