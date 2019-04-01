local BaseScene = class("BaseScene", function()
    return cc.Scene:create()
end)

function BaseScene:ctor(...)
    self:setNodeEventEnabled(true)
    self:init_()
    self:onCreate(...)
    self:bindCtr()
end

-- Overwrite Me
function BaseScene:onCreate(...)
end

function BaseScene:init_()
    g_BehaviorExtend(self)
end

function BaseScene:onCleanup()
    self:unBindAllBehavior()
    self:onDestroy()
end

-- Overwrite Me
function BaseScene:onDestroy()
end

function BaseScene:getCtr()
    return self.Ctr_
end

function BaseScene:bindCtr()
    if self.Ctr_ then
        return
    end
    self.Ctr_ = self:buildCtr()
    self:add(self.Ctr_)
end

-- Overwrite Me
function BaseScene:buildCtr()
    return g_BaseCtr.new()
end

return BaseScene
