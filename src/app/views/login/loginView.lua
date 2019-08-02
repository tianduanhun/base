local LoginView = class("LoginView", g_BaseView)

function LoginView:onCreate(...)
end

function LoginView:onEnter()
    local text = ccui.Text:create("登录", "", 40):addTo(self):align(display.CENTER, display.cx, display.cy)
    text:onTouch(function(event)
        if event.isClick then
            self:doLogic("requestLogin")
        end
    end)
end

function LoginView:onDestroy()
end
--------------------------------------------------


return LoginView
