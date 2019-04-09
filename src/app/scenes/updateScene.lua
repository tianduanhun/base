local Updater = require("app.scenes.Updater")

local UpdateScene = class("UpdateScene", function ( )
    return display.newScene()
end)

function UpdateScene:ctor()
    -- Updater.init("UpdateScene", "", function (code, param1, param2)
    --     if code == 1 then
    --         self:enterGame()
    --     elseif code == 2 then
    --         print("total size : " .. param1, "current size : " .. param2)
    --     elseif code == 3 or code == 4 or code == 5 then
    --         print("network error, code : " .. code)
    --     elseif code == 6 then
    --         print("engine is old")
    --     elseif code == 7 then
    --         device.showAlert("title","message",{"yes", "no"},function (event)
    --             if event.buttonIndex == 1 then
    --                 param2()
    --             end
    --         end)
    --     end
    -- end)
end

function UpdateScene:onEnter()
    -- for test
    self:enterGame()
end

function UpdateScene:enterGame()
    require("frameworkEx.init")
    g_Extend.AppBaseExtend.new():run()
end

function UpdateScene:onCleanup()
    Updater = nil
    package.loaded["app.scenes.Updater"] = nil
    package.loaded["app.scenes.updateScene"] = nil
end

return UpdateScene