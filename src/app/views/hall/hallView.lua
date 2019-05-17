local HallView = class("HallView", g_BaseView)

function HallView:onCreate(...)
end

function HallView:getCtrClass()
    return require("hallCtr")
end

function HallView:onEnter()
    local btn = ccui.Button:create(PKGPATH .. "1.png", PKGPATH .. "1.png", PKGPATH .. "1.png"):addTo(self):align(display.BOTTOM_CENTER, display.cx, 0)
    display.makeGray(btn)
    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            app:pushView(app:createView("hall"):scale(0.5):pos(math.random(0, display.cx), math.random(0, display.cy)))
        end
    end)
    btn:setTouchEnabled(true)

    local btn2 = ccui.Button:create(PKGPATH .. "1.png", PKGPATH .. "1.png", PKGPATH .. "1.png"):addTo(self):align(display.TOP_CENTER, display.cx, display.height)
    display.makeBlur(btn2)
    btn2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            -- app:popView()
            -- app:pushToast(math.random())
            
            local bg = display.captureBlurScene()
            bg:align(display.CENTER, display.cx, display.cy)
            app:pushView(bg, {isFull = true})
        end
    end)
    btn2:setTouchEnabled(true)

    display.newTTFLabel({text = "测试文字", font = "app/common/res/fonts/XianEr.ttf", size = 32}):addTo(self):align(display.CENTER, display.cx, display.cy)
    display.newTTFLabel({text = "测试文字", font = "app/common/res/fonts/XianEr.ttf", size = 26}):addTo(self):align(display.CENTER, display.cx, display.cy - 30)
    display.newTTFLabel({text = "测试文字", font = "app/common/res/fonts/XianEr.ttf", size = 20}):addTo(self):align(display.CENTER, display.cx, display.cy - 60)


end

function HallView:onDestroy()
end
--------------------------------------------------

return HallView
