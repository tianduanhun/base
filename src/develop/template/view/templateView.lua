local TemplateView = class("TemplateView", g_BaseView)

function TemplateView:onCreate(...)
end

function TemplateView:getCtrClass()
    return require("templateCtr")
end

function TemplateView:onEnter()
end

function TemplateView:onDestroy()
end
--------------------------------------------------


return TemplateView
