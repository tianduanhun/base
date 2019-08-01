local TemplateData = class("TemplateData", g_BaseData)

local pbConfig = require("proto.pbConfig")
local templateConfig = require("config.config")

--{key = funcName}
TemplateData.registerEvents = {}
TemplateData.exportFuncs = {}

function TemplateData:onCreate()
end

function TemplateData:onDestroy()
end

return TemplateData