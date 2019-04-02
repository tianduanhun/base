
require("cocos.init")
require("framework.init")

require("frameworkEx.init")

local AppBase = import("frameworkEx.extend").appBaseExtend
local MyApp = class("MyApp", AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("hall")
end

return MyApp
