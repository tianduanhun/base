local BaseCtr = class("BaseCtr")

BaseCtr.registerEvents = {}
BaseCtr.exportFuncs = {}

function BaseCtr:ctor(_UI, ...)
    self._UI = _UI
    self:_init()
    self:onCreate(...)
end

-- Override Me
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

-- Override Me
function BaseCtr:onDestroy()
end

function BaseCtr:_handler(methodName, ...)
    if methodName and self[methodName] then
        self[methodName](self, ...)
    else
        print(self.__cname, methodName .. " method does not exist")
    end
end

function BaseCtr:doView(methodName, ...)
    if self._UI and self._UI._handler then
        return self._UI:_handler(methodName, ...)
    end
end

return BaseCtr
