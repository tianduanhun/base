local NativeCall = {}

local callStaticMethod
local platform = cc.Application:getInstance():getTargetPlatform()
if platform == cc.PLATFORM_OS_ANDROID then
    callStaticMethod = LuaJavaBridge.callStaticMethod
elseif platform == cc.PLATFORM_OS_MAC or platform == cc.PLATFORM_OS_IPHONE then
    callStaticMethod = LuaObjcBridge.callStaticMethod
else
    callStaticMethod = function(...)
        return false, "platform is not ios or android"
    end
end

local signConfig = {
    ["number"] = "F",
    ["boolean"] = "Z",
    ["string"] = "Ljava/lang/String;",
    ["function"] = "I"
}

local className = "top.bogeys.export.ExportFunc"
-- result:返回数据类型, default:默认返回值, param:参数对应字段和类型
local config = {
    getUUID = {result = "string", default = ""}, --获取UUID
    saveUUID = {param = {"uuid:string"}} --保存UUID
}

local function getSign(method)
    local data = config[method]
    local sign = "("
    if data.param and not table.isEmpty(data.param) then
        for k, v in ipairs(data.param) do
            local paramType = (string.split(v, ":"))[2]
            if signConfig[paramType] then
                sign = sign .. signConfig[paramType]
            else
                error("not such type param")
            end
        end
    end
    sign = sign .. ")"
    if data.result and signConfig[data.result] then
        sign = sign .. signConfig[data.result]
    else
        sign = sign .. "V"
    end
    return sign
end

local function checkParams(method, params)
    local data = config[method].param or {}
    for i, v in ipairs(data) do
        if not params then
            error(method .. " params is empty")
        end
        if not params[i] then
            error(method .. " params #" .. i .. " is empty")
        end
        if type(params[i]) ~= (string.split(v, ":"))[2] then
            error(method .. " params #" .. i .. " type is error")
        end
    end
end

function NativeCall.callSystem(method, params)
    assert(method and config[method], "method is not exist : " .. method)
    checkParams(method, params)
    params = checktable(params)
    local bool, result = callStaticMethod(className, method, params, getSign(method))
    if bool then
        return result
    else
        print(method .. " call failed", result)
        return config[method].default
    end
end

return NativeCall
