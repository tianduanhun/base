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

function BaseCtr:ctor(_UI, ...)
    self._UI = _UI
    self:_init()
    self:onCreate(...)
end

-- Overwrite Me
function BaseCtr:onCreate(...)
end

function BaseCtr:_init()
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)
    self:registerEvent()
end

function BaseCtr:onCleanup()
    self:unRegisterEvent()
    self:unBindAllBehavior()
    self._UI = nil
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
    if self._UI and self._UI.haldler then
        return self._UI:haldler(methodName, ...)
    end
end

return BaseCtr
