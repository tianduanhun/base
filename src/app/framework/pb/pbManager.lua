local CURRENT_MODULE_NAME = ...
CURRENT_MODULE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -11)

require("protobuf")

local PbManager = {}

--[key] = {pb = protoName, pkg = pkg, requestMsg = 'c2s_Message_Name', responseMsg = 's2c_Message_Name'}
PbManager.config = {}

PbManager.pbFile = {}

PbManager.msgType = {
    request = "requestMsg",
    response = "responseMsg"
}

local function _getProto(msgType, pbkey)
    local config = PbManager.config[pbkey]
    if config then
        if not PbManager.pbFile[config.pb] then
            local data = g_FileUtils.getFileContent(config.pb)
            if string.isEmpty(data) then
                error("load .pb file failed :" .. config.pb)
            end
            protobuf.register(data)
            PbManager.pbFile[config.pb] = true
        end
        return config.pkg .. "." .. config[msgType]
    end
end

function PbManager.register(config)
    config = checktable(config)
    for k, v in pairs(config) do
        PbManager.config[k] = v
    end
end

function PbManager.encode(pbKey, data)
    local proto = _getProto(PbManager.msgType.request, pbKey)
    return protobuf.encode(proto, data)
end

function PbManager.decode(pbKey, data)
    local proto = _getProto(PbManager.msgType.response, pbKey)
    return protobuf.decode(proto, data)
end


return PbManager
