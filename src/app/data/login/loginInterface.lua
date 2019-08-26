local LoginInterface = class("LoginInterface", g_BaseData)

local pbConfig = require("proto.pbConfig")
local loginConfig = require("config.config")
local loginData = require("data.loginData"):getInstance()

--{key = funcName}
LoginInterface.registerEvents = {
    [pbConfig.method.LOGIN] = "onResponseLogin"
}
LoginInterface.exportFuncs = {
    "requestLogin"
}

function LoginInterface:onCreate()
    self:setNotifyFuncName("onLoginNotify")
end

function LoginInterface:onDestroy()
    loginData:destroy()
end
--------------------------------------------------
function LoginInterface:requestLogin(account, password)
    local sendData = {
        account = account,
        password = password,
        appVersion = 1
    }
    g_SocketManager:send(pbConfig.method.LOGIN, sendData)
end

function LoginInterface:onResponseLogin(data)
    data = checktable(data)
    if data.code == 0 then
        self:notifyObserver(loginConfig.opcode.LOGIN, true, data.msg, data)
    end
end

return LoginInterface