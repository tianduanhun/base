local AppBase = _require("framework.AppBase")
local scheduler = _require("framework.scheduler")
local BaseScene = require("BaseScene")
local AppBaseExtend = class("AppBaseExtend", AppBase)

function AppBaseExtend:enterScene(viewName, ...)
    local view = self:createView(viewName, ...)
    self._BaseScene:pushView(view)
end

function AppBaseExtend:createView(viewName, ...)
    local viewPackageName = "app.views." .. viewName
    local viewClass = import(viewPackageName).getView()
    return viewClass.new(...)
end

function AppBaseExtend:run()
    local scene = self._BaseScene
    if not scene or scene.__cname ~= "BaseScene" then
        scene = BaseScene.new()
        display.replaceScene(scene)
        self._BaseScene = scene
    end

    -- 必须延迟一帧加载
    scheduler.performWithDelayGlobal(function()
        self:enterScene("hall")
    end, 0)
end

function AppBaseExtend:onEnterBackground()
    print("onEnterBackground")
end

function AppBaseExtend:onEnterForeground()
    print("onEnterForeground")
end

return AppBaseExtend
