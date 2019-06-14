local pb = _require("pb")

local g_PbManager = {}

--[key] = {pb = protoName, pkg = pkg, requestMsg = 'c2s_Message_Name', responseMsg = 's2c_Message_Name'}
g_PbManager.config = {}

g_PbManager.pbFile = {}

g_PbManager.msgType = {
    request = "requestMsg",
    response = "responseMsg"
}

local function _getProto(msgType, pbkey)
    local config = g_PbManager.config[pbkey]
    if config then
        if not g_PbManager.pbFile[config.pb] then
            local data = g_FileUtils.getFileContent(config.pb)
            if string.isEmpty(data) then
                error("load .pb file failed :" .. config.pb)
            end
            pb.load(data)
            g_PbManager.pbFile[config.pb] = true
        end
        return config.pkg .. "." .. config[msgType]
    end
end

function g_PbManager.register(config)
    config = checktable(config)
    for k, v in pairs(config) do
        if g_PbManager.config[k] then
            error("The configured key value already exists : " .. k)
        end
        g_PbManager.config[k] = v
    end
end

function g_PbManager.encode(pbKey, data)
    local proto = _getProto(g_PbManager.msgType.request, pbKey)
    return pb.encode(proto, data)
end

function g_PbManager.decode(pbKey, data)
    local proto = _getProto(g_PbManager.msgType.response, pbKey)
    return pb.decode(proto, data)
end


return g_PbManager
