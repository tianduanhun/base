local LoginView = class("LoginView", g_BaseView)

function LoginView:onCreate(...)
end

function LoginView:onEnter()
    self:initView()
end

function LoginView:onDestroy()
end
--------------------------------------------------
function LoginView:initView()
    local text = ccui.Text:create("登录", "", 40):addTo(self):align(display.CENTER, display.cx, display.cy)
    text:onTouch(function(event)
        if event.isClick then
            self:doLogic("requestLogin")
        end
    end)
end


return LoginView
