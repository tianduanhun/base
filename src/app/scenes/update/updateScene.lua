local Updater = require("app.scenes.update.Updater")

local UpdateScene = class("UpdateScene", function ()
    return display.newScene()
end)

function UpdateScene:ctor()
    -- Updater.init("update.updateScene", "http://localhost:8080/address", function (code, param1, param2)
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
    require("app.common.init")
    require("app.scenes.main.appBaseExtend").new():run("login")
end

function UpdateScene:onCleanup()
    Updater = nil
    package.loaded["app.scenes.update.Updater"] = nil
    package.loaded["app.scenes.update.updateScene"] = nil
end

return UpdateScene