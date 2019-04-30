local AppBase = _require("framework.AppBase")
local scheduler = _require("framework.scheduler")
local MainScene = _require("app.scenes.main.mainScene")
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
    local scene = MainScene.new()
    display.replaceScene(scene)
    self._BaseScene = scene
    unimport("app.data")
    unimport("app.views")

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
