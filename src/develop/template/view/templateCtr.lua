local TemplateCtr = class("TemplateCtr", g_BaseCtr)
--[[
local templateConfig = import("app.data.template").getConfig()
local templateInterface = import("app.data.template").getData()
]]
--{key = funcName}
TemplateCtr.registerEvents = {}
TemplateCtr.exportFuncs = {}

function TemplateCtr:onCreate(...)
--[[    templateInterface:doMethod("addObserver", self)]]
end

function TemplateCtr:onDestroy()
end
--------------------------------------------------
--[[function TemplateCtr:onTemplateNotify(opcode, bool, msg, data)
end]]


return TemplateCtr
