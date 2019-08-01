local LoginCtr = class("LoginCtr", g_BaseCtr)

local LoginData = import("app.data.login").getData()
--{key = funcName}
LoginCtr.registerEvents = {}
LoginCtr.exportFuncs = {}

function LoginCtr:onCreate(...)
end

function LoginCtr:onDestroy()
end
--------------------------------------------------

return LoginCtr
