local pb = PKGPATH .. "proto/login.pb"
local pkg = "login"

local config = {}

config.method = {
    LOGIN = "api-login.login"
}

config.protoConfig = {
    [config.method.LOGIN] = {pb = pb, pkg = pkg, requestMsg = "loginReq", responseMsg = "loginResp"},
}

g_PbManager.register(config.protoConfig)

return config