local BaseCtr = class("BaseCtr")

function BaseCtr:getInstance()
    if self.instance == nil then
        self.instance = self.new()
    end
    return self.instance
end

function BaseCtr:destroy()
    self.instance:onCleanup()
    self.instance = nil
end
--------------------------------------------

BaseCtr.registerEvents = {}
BaseCtr.exportFuncs = {}

function BaseCtr:ctor(UI_, ...)
    self.UI_ = UI_
    self:init_()
    self:onCreate(...)
end

-- Overwrite Me
function BaseCtr:onCreate(...)
end

function BaseCtr:init_()
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)
    self:registerEvent()
end

function BaseCtr:onCleanup()
    self:unRegisterEvent()
    self:unBindAllBehavior()
    self.UI_ = nil
    self:onDestroy()
end

-- Overwrite Me
function BaseCtr:onDestroy()
end

function BaseCtr:handler(methodName, ...)
    if methodName and self[methodName] then
        self[methodName](self, ...)
    end
end

function BaseCtr:doView(methodName, ...)
    if self.UI_ and self.UI_.haldler then
        return self.UI_:haldler(methodName, ...)
    end
end

return BaseCtr
