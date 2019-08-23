local TemplateCtr = class("TemplateCtr", g_BaseCtr)
--[[
local templateDataModule = app:getDataModule("template")
local templateInterface = templateDataModule.getData()
local templateConfig = templateDataModule.getConfig()
]]
--{key = funcName}
TemplateCtr.registerEvents = {}

function TemplateCtr:onCreate(...)
--[[    templateInterface:doMethod("addObserver", self)]]
end

function TemplateCtr:onDestroy()
--[[    templateInterface:doMethod("removeObserver", self)]]
end
--------------------------------------------------
--[[function TemplateCtr:onTemplateNotify(opcode, bool, msg, data)
end]]


return TemplateCtr
