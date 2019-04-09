local AppBase = _require("framework.AppBase")
local BaseScene = require("BaseScene")
local AppBaseExtend = class("AppBaseExtend", AppBase)

function AppBaseExtend:enterScene(viewName, ...)
    local scene = display.getRunningScene()
    if not scene or scene.__cname ~= "BaseScene" then
        scene = BaseScene.new()
        display.replaceScene(scene)
    end
    local view = self:createView(viewName, ...)
    scene:pushView(view)
end

function AppBaseExtend:createView(viewName, ...)
    local viewPackageName = "app.views." .. viewName
    local viewClass = import(viewPackageName).getView()
    return viewClass.new(...)
end

function AppBaseExtend:run()
    self:enterScene("hall")
end

function AppBaseExtend:onEnterBackground()
    print("onEnterBackground")
end

function AppBaseExtend:onEnterForeground()
    print("onEnterForeground")
end

return AppBaseExtend