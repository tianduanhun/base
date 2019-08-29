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
BaseData.exportFuncs = {
    bind = "addObserver",         --绑定这个数据接口时需要调用的方法
    unBind = "removeObserver",    --解绑时需要调用
}

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
    table.fill(self.exportFuncs, self.super.exportFuncs)
end

function BaseData:onCleanup()
    self:unRegisterEvent()
    self:removeAllObserver()
    self:unBindAllBehavior()
    self:onDestroy()
end

-- Override Me
function BaseData:onDestroy()
end

function BaseData:doMethod()
    print("Behavior is already drop")
end

function BaseData:doMethodByKey()
    print("Behavior is already drop")
end

return BaseData