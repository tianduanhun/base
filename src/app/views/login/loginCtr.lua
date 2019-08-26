local LoginCtr = class("LoginCtr", g_BaseCtr)

--{key = funcName}
LoginCtr.registerEvents = {}

function LoginCtr:onCreate(...)
    self:bindDataSource("login")
end

function LoginCtr:onDestroy()
end
--------------------------------------------------
function LoginCtr:onLoginNotify(opcode, bool, msg, data)
    if opcode == LoginConfig.opcode.LOGIN then
        self:doView("loginSuccess")
    end
end

function LoginCtr:requestLogin()
    local account = "abcde"
    local password = "12345"
    LoginInterface:doMethod("requestLogin", account, password)
end


return LoginCtr
