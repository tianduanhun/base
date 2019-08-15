local BaseView = class("BaseView", function()
    return cc.Node:create()
end)

function BaseView:ctor(...)
    self:_init()
    self:bindCtr(...)
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

function BaseView:bindCtr(...)
    self._Ctr = self:getCtrClass().new(self, ...)
end

function BaseView:doLogic(methodName, ...)
    if self._Ctr and self._Ctr._handler then
        return self._Ctr:_handler(methodName, ...)
    end
end

function BaseView:_handler(methodName, ...)
    if methodName and self[methodName] then
        return self[methodName](self, ...)
    else
        print(self.__cname, methodName .. " method does not exist")
    end
end

return BaseView
