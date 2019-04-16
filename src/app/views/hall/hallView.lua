local HallView = class("HallView", g_BaseView)

function HallView:onCreate(...)
end

function HallView:getCtrClass()
    return require("hallCtr")
end

function HallView:onEnter()
    local node = cc.DrawNode:create()
    node:drawDot(cc.p(display.cx, display.height), 3, cc.c4f(1,1,1,1))
    cc.Director:getInstance():setNotificationNode(node)
end

function HallView:onDestroy()
end
--------------------------------------------------


return HallView
