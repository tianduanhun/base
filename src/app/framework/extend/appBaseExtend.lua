local AppBase = _require("framework.AppBase")
local AppBaseExtend = class("AppBaseExtend", AppBase)

function AppBaseExtend:enterSceneWithAni(sceneName, transitionType, time, more, ...)
    local scenePackageName = "app.scenes." ..sceneName
    local sceneClass = import(scenePackageName).getScene()
    local scene = sceneClass.new(...)
    display.replaceScene(scene, transitionType, time, more)
end

function AppBaseExtend:enterScene(sceneName, ...)
    self:enterSceneWithAni(sceneName, nil, nil, nil, ...)
end

function AppBaseExtend:createView(viewName, ...)
    local viewPackageName = "app.views." .. viewName
    local viewClass = import(viewPackageName).getView()
    return viewClass.new(...)
end

return AppBaseExtend