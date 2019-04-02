local TemplateCtr = class("TemplateCtr", g_BaseCtr)

--{key = funcName}
TemplateCtr.registerEvents = {}
TemplateCtr.exportFuncs = {}

function TemplateCtr:onCreate(...)
end

function TemplateCtr:onDestroy()
end
--------------------------------------------------

return TemplateCtr
