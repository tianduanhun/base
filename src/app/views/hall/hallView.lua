local HallView = class("HallView", g_BaseView)

function HallView:onCreate(...)
end

function HallView:onEnter()
    app:pushToast("123abc测试文字")
end

function HallView:onDestroy()
end
--------------------------------------------------

return HallView
