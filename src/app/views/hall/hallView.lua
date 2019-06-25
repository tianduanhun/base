local HallView = class("HallView", g_BaseView)

function HallView:onCreate(...)
end

function HallView:onEnter()
    local text = ccui.Text:create("测试文字", "", 30):addTo(self):align(display.CENTER, display.cx, display.cy)
    text:onTouch(function (event)
        dump(event, event.name)
    end)

    local btn = ccui.Button:create(PKGPATH .. "1.png"):addTo(self):align(display.CENTER, display.cx, display.cy - 100)
    btn:onTouch(function (event )
        dump(event, event.name)
    end)

    local sp = cc.Sprite:create(PKGPATH .. "1.png"):addTo(self):align(display.CENTER, display.cx, display.cy + 100)
    sp:onTouch(function (event )
        dump(event, event.name)
    end)
end

function HallView:onDestroy()
end
--------------------------------------------------

return HallView
