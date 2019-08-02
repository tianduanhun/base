local TemplateCtr = class("TemplateCtr", g_BaseCtr)
--[[
local templateInterface, Template = app:getDataModule("template")
local templateConfig = Template.getConfig()
]]
--{key = funcName}
TemplateCtr.registerEvents = {}

function TemplateCtr:onCreate(...)
--[[    templateInterface:doMethod("addObserver", self)]]
end

function TemplateCtr:onDestroy()
end
--------------------------------------------------
--[[function TemplateCtr:onTemplateNotify(opcode, bool, msg, data)
end]]


return TemplateCtr
