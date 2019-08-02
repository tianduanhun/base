local TemplateInterface = class("TemplateInterface", g_BaseData)

local pbConfig = require("proto.pbConfig")
local templateConfig = require("config.config")
local templateData = require("data.templateData"):getInterface()

--{key = funcName}
TemplateInterface.registerEvents = {}
TemplateInterface.exportFuncs = {
    "addObserver",
    "removeObserver",
}

function TemplateInterface:onCreate()
    self:setNotifyFuncName("onTemplateNotify")
end

function TemplateInterface:onDestroy()
    templateData:destroy()
end
--------------------------------------------------


return TemplateInterface