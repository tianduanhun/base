local LoginCtr = class("LoginCtr", g_BaseCtr)

local loginInterface, Login = app:getDataModule("login")
local loginConfig = Login.getConfig()

--{key = funcName}
LoginCtr.registerEvents = {}

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
