local HallView = class("HallView", g_BaseView)

function HallView:onCreate(...)
end

function HallView:getCtrClass()
    return require("hallCtr")
end

function HallView:onEnter()
    local pb = _require("pb")
    dump(pb)
end

function HallView:onDestroy()
end
--------------------------------------------------

return HallView
