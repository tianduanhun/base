local pb = PKGPATH .. "proto/template.pb"
local pkg = "template"

local config = {}

config.method = {
    XXX = "template.xxx"
}

config.protoConfig = {
    [config.method.XXX] = {pb = pb, pkg = pkg, requestMsg = "xxxReq", responseMsg = "xxxResp"},
}

g_PbManager.register(config.protoConfig)

return config