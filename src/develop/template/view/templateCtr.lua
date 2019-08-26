local TemplateCtr = class("TemplateCtr", g_BaseCtr)

--{key = funcName}
TemplateCtr.registerEvents = {}

function TemplateCtr:onCreate(...)
--[[    self:bindDataSource("template")]]
end

function TemplateCtr:onDestroy()
end
--------------------------------------------------
--[[function TemplateCtr:onTemplateNotify(opcode, bool, msg, data)
end]]


return TemplateCtr
