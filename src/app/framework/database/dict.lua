local M = {}

local UserDefault = cc.UserDefault:getInstance()

function M.load(name)
    local str = UserDefault:getStringForKey(name)
    str = crypto.decodeBase64(str)
    return json.decode(str)
end

function M.save(name, data)
    local str = json.encode(data)
    str = crypto.encodeBase64(str)
    UserDefault:setStringForKey(name, str)
end

return M