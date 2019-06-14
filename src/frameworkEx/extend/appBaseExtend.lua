local AppBase = _require("framework.AppBase")
local scheduler = _require("framework.scheduler")
local MainScene = require("mainScene")
local AppBaseExtend = class("AppBaseExtend", AppBase)

function AppBaseExtend:enterScene(viewName, ...)
    local view = self:createView(viewName, ...)
    self._BaseScene:pushScene(view)
end

function AppBaseExtend:createView(viewName, ...)
    local viewPackageName = "app.views." .. viewName
    local viewClass = import(viewPackageName).getView()
    return viewClass.new(...)
end

function AppBaseExtend:pushView(view, param)
    self._BaseScene:pushView(view, param)
end

function AppBaseExtend:popView(view)
    self._BaseScene:popView(view)
end

function AppBaseExtend:pushToast(str)
    self._BaseScene:pushToast(str)
end

function AppBaseExtend:run(viewName)
    local scene = MainScene.new()
    display.replaceScene(scene)
    self._BaseScene = scene
    unimport("app.data")
    unimport("app.views")

    -- 必须延迟一帧加载
    scheduler.performWithDelayGlobal(function()
        self:enterScene(viewName)
    end, 0)
end

function AppBaseExtend:onEnterBackground()
    print("onEnterBackground")
end

function AppBaseExtend:onEnterForeground()
    print("onEnterForeground")
end

return AppBaseExtend
