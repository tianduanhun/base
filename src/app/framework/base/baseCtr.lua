local BaseCtr = class("BaseCtr", function()
    return cc.Node:create()
end)

BaseCtr.registerEvents = {}
BaseCtr.exportFuncs = {}

function BaseCtr:ctor(...)
    self:setNodeEventEnabled(true)
    self:init_()
    self:onCreate(...)
    self:createUI()
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

function BaseCtr:getUI()
    return self.UI_
end

function BaseCtr:createUI()
    if self.UI_ then
        return
    end
    self.UI_ = self:buildUI()
    self:add(self.UI_)
end

-- Overwrite Me
function BaseCtr:buildUI()
    return g_BaseView.new(self)
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

-- 执行上层控制器逻辑
function BaseCtr:doUpLayerLogic(methodName, ...)
    local parent = self:getParent()
    if parent and parent.doLogic then
        parent:doLogic(methodName, ...)
    end
end

return BaseCtr
