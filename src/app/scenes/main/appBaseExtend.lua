local AppBase = _require("framework.AppBase")
local MainScene = _require("app.scenes.main.mainScene")
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

function AppBaseExtend:getDataModule(moduleName)
    local dataModuleName = "app.data." .. moduleName
    local dataModule = import(dataModuleName)
    return dataModule
end

function AppBaseExtend:pushView(view, param)
    self._BaseScene:pushView(view, param)
end

function AppBaseExtend:popView(view)
    self._BaseScene:popView(view)
end

function AppBaseExtend:getTopView()
    return self._BaseScene:getTopView()
end

function AppBaseExtend:popAllView()
    self._BaseScene:popAllView()
end

function AppBaseExtend:pushToast(str)
    self._BaseScene:pushToast(str)
end

function AppBaseExtend:run(viewName)
    g_App = self
    local scene = MainScene.new()
    display.replaceScene(scene)
    self._BaseScene = scene
    -- unimport("app.data")
    -- unimport("app.views")

    -- 必须延迟一帧加载
    g_Scheduler.performWithDelayGlobal(function()
        self:enterScene(viewName)
    end, 0)
end

function AppBaseExtend:onEnterBackground()
    print("onEnterBackground")
end

function AppBaseExtend:onEnterForeground()
    print("onEnterForeground")
    g_SocketManager:doMethod("reConnect")
end

return AppBaseExtend
