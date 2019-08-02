local LoginCtr = class("LoginCtr", g_BaseCtr)

local loginConfig = import("app.data.login").getConfig()
local loginInterface = import("app.data.login").getData()

--{key = funcName}
LoginCtr.registerEvents = {}
LoginCtr.exportFuncs = {}

function LoginCtr:onCreate(...)
    loginInterface:doMethod("addObserver", self)
end

function LoginCtr:onDestroy()
end
--------------------------------------------------
function LoginCtr:onLoginNotify(opcode, bool, msg, data)
    if opcode == loginConfig.opcode.LOGIN then
        self:doView("loginSuccess")
    end
end

function LoginCtr:requestLogin()
    local account = "abcde"
    local password = "12345"
    loginInterface:doMethod("requestLogin", account, password)
end


return LoginCtr
