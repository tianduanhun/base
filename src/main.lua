package.path = package.path .. ";src/?.lua"
require("config")

local breakSocketHandle, debugXpCall
if DEBUG > 0 then
    breakSocketHandle, debugXpCall = require("LuaDebugjit")("localhost", 7003)
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakSocketHandle, 0.3, false)
end

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    if debugXpCall then
        debugXpCall()
    end
    if USE_BUGLY and buglyReportLuaException then
        buglyReportLuaException(tostring(errorMessage), debug.traceback("", 2))
    end
end

require("app.MyApp").new():run()
