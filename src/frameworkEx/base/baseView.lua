local BaseView = class("BaseView", function()
    return cc.Node:create()
end)

function BaseView:ctor(...)
    self:_init()
    self:bindCtr()
    self:onCreate(...)
end

-- Override Me
function BaseView:onCreate(...)
    error("Must override the onCreate method")
end

function BaseView:_init()
    self:setNodeEventEnabled(true)
    self:setCascadeOpacityEnabled(true)
    self:align(display.CENTER, display.cx, display.cy):size(display.size)
    g_BehaviorExtend(self)
end

function BaseView:onCleanup()
    self:unBindAllBehavior()
    self._Ctr:onCleanup()
    self._Ctr = nil
    self:onDestroy()
end

-- Override Me
function BaseView:onDestroy()
end

function BaseView:getCtrClass()
    local env = getfenv(self.onCreate)
    return env.require(string.lowerFirst(string.gsub(self.__cname, "View", "Ctr")))
end

function BaseView:bindCtr()
    self._Ctr = self:getCtrClass().new(self)
end

function BaseView:doLogic(methodName, ...)
    if self._Ctr and self._Ctr._handler then
        return self._Ctr:_haldler(methodName, ...)
    end
end

function BaseView:_handler(methodName, ...)
    if methodName and self[methodName] then
        self[methodName](self, ...)
    end
end

function BaseView:enterAction()
    self:setOpacity(0)
    self:setScale(0.8)
    self:runAction(cc.Spawn:create(
        cc.FadeIn:create(0.1),
        cc.EaseBackInOut:create(cc.ScaleTo:create(0.1, 1))
    ))
end

function BaseView:exitAction()
    self:runAction(cc.Spawn:create(
            cc.FadeOut:create(0.1),
            cc.EaseBackInOut:create(cc.ScaleTo:create(0.1, 0.8))
        )
    )
    return 0.1
end

return BaseView
