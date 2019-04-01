local BaseView = class("BaseView", function()
    return cc.Node:create()
end)

function BaseView:ctor(Ctr_, ...)
    self.Ctr_ = Ctr_
    self:setNodeEventEnabled(true)
    self:init_()
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
    self.Ctr_ = nil
    self:onDestroy()
end

-- Overwrite Me
function BaseView:onDestroy()
end

function BaseView:getCtr()
    return self.Ctr_
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
