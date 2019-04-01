package.path = package.path .. ";src/?.lua"
require("config")

local breakSocketHandle, debugXpCall = require("LuaDebugjit")("localhost", 7003)
cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakSocketHandle, 0.3, false)

local function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    debugXpCall()
end

local function main()
    require("app.MyApp").new():run()
end

xpcall(main, __G__TRACKBACK__)
