local LoginData = class("LoginData", g_BaseData)

local pbConfig = require("proto.pbConfig")
local loginConfig = require("config.config")

--{key = funcName}
LoginData.registerEvents = {}
LoginData.exportFuncs = {}

function LoginData:onCreate()
end

function LoginData:onDestroy()
end

return LoginData