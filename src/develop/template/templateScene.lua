local TemplateScene = class("TemplateScene", g_BaseScene)

--初始化到显示 方法执行顺序 onCreate -> buildCtr -> onEnter
function TemplateScene:onCreate(...)
end

function TemplateScene:buildCtr()
    return require("templateCtr").new(self)
end

function TemplateScene:onEnter()
end

function TemplateScene:onDestroy()
end
--------------------------------------------------

return TemplateScene
