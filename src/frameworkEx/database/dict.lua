local M = {}

local UserDefault = cc.UserDefault:getInstance()

function M.load(name)
    assert(name and type(name) == "string", "save key is not string")
    local str = UserDefault:getStringForKey(name)
    str = crypto.decodeBase64(str)
    return json.decode(str)
end

function M.save(name, data)
    assert(name and type(name) == "string", "save key is not string")
    local str = json.encode(data)
    str = crypto.encodeBase64(str)
    UserDefault:setStringForKey(name, str)
end

return M