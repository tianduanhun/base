local TemplateCtr = class("TemplateCtr", g_BaseCtr)

--初始化到显示 方法执行顺序 onCreate -> buildUI -> onEnter
--返回需要注册监听表{key = funcName}
TemplateCtr.registerEvents = {}
TemplateCtr.exportFuncs = {}

function TemplateCtr:onCreate(...)
end

function TemplateCtr:buildUI()
    return require("templateView").new(self)
end

function TemplateCtr:onEnter()
end

function TemplateCtr:onDestroy()
end
--------------------------------------------------

return TemplateCtr
