local HallView = class("HallView", g_BaseView)

function HallView:onCreate(...)
end

function HallView:getCtrClass()
    return require("hallCtr")
end

function HallView:onEnter()
end

function HallView:onDestroy()
end
--------------------------------------------------

return HallView
