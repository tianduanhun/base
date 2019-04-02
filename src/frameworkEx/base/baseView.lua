local BaseView = class("BaseView", function()
    return cc.Node:create()
end)

function BaseView:ctor(...)
    self:setNodeEventEnabled(true)
    self:init_()
    self:bindCtr()
    self:onCreate(...)
end

-- Overwrite Me
function BaseView:onCreate(...)
end

function BaseView:init_()
    g_BehaviorExtend(self)
end

function BaseView:onCleanup()
    self:unBindAllBehavior()
    self.Ctr_:destroy()
    self.Ctr_ = nil
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
    self.Ctr_ = self:getCtrClass():getInstance()
end

function BaseView:doLogic(methodName, ...)
    if self.Ctr_ and self.Ctr_.haldler then
        return self.Ctr_:haldler(methodName, ...)
    end
end

function BaseView:handler(methodName, ...)
    if methodName and self[methodName] then
        self[methodName](self, ...)
    end
end

return BaseView
