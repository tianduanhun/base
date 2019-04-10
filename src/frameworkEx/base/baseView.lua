local BaseView = class("BaseView", function()
    return cc.Node:create()
end)

function BaseView:ctor(...)
    self:setNodeEventEnabled(true)
    self:_init()
    self:bindCtr()
    self:onCreate(...)
end

-- Overwrite Me
function BaseView:onCreate(...)
end

function BaseView:_init()
    g_BehaviorExtend(self)
end

function BaseView:onCleanup()
    self:unBindAllBehavior()
    self._Ctr:destroy()
    self._Ctr = nil
    self:onDestroy()
end

-- Overwrite Me
function BaseView:onDestroy()
end

-- Overwrite Me
function BaseView:getCtrClass()
    return g_BaseCtr
end

function BaseView:bindCtr()
    self._Ctr = self:getCtrClass():getInstance()
end

function BaseView:doLogic(methodName, ...)
    if self._Ctr and self._Ctr.haldler then
        return self._Ctr:haldler(methodName, ...)
    end
end

function BaseView:handler(methodName, ...)
    if methodName and self[methodName] then
        self[methodName](self, ...)
    end
end

return BaseView
