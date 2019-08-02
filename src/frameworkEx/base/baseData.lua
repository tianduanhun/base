local BaseData = class("BaseData")

function BaseData:getInstance()
    if self.instance == nil then
        self.instance = self.new()
    end
    return self.instance
end

function BaseData:destroy()
    self.instance:onCleanup()
    self.instance = nil
end
--------------------------------------------------
BaseData.registerEvents = {}
BaseData.exportFuncs = {}

function BaseData:ctor()
    self:_init()
    self:onCreate()
end

-- Override Me
function BaseData:onCreate()
    error("Must override the onCreate method")
end

function BaseData:_init()
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)
    self:registerEvent()
    self:bindBehavior(g_BehaviorMap.observerBehavior)
end

function BaseData:onCleanup()
    self:unRegisterEvent()
    self:unBindAllBehavior()
    self:removeAllObserver()
    self:onDestroy()
end

-- Override Me
function BaseData:onDestroy()
end

return BaseData