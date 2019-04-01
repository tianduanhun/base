local BaseDataInterface = class("BaseDataInterface")

BaseDataInterface.registerEvents = {}
BaseDataInterface.exportFuncs = {}

function BaseDataInterface:ctor()
    self:init_()
    self:onCreate()
end

-- Overwrite Me
function BaseDataInterface:onCreate(...)
end

function BaseDataInterface:init_()
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)
    self:registerEvent()
end

function BaseDataInterface:onCleanup()
    self:unRegisterEvent()
    self:unBindAllBehavior()
    self:onDestroy()
end

-- Overwrite Me
function BaseDataInterface:onDestroy()
end

return BaseDataInterface