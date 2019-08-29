local TemplateView = class("TemplateView", g_BaseView)

function TemplateView:onCreate(...)
end

function TemplateView:onEnter()
    self:initView()
end

function TemplateView:onDestroy()
end
--------------------------------------------------
function TemplateView:initView()
end


return TemplateView
