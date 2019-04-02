local AppBase = _require("framework.AppBase")
local BaseScene = require("baseScene")
local AppBaseExtend = class("AppBaseExtend", AppBase)

function AppBaseExtend:enterScene(viewName, ...)
    local scene = display.getRunningScene()
    if not scene then
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

return AppBaseExtend