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
-------------------------------------------
function BaseData:ctor(...)
    self:_init()
    self:onCreate(...)
end

-- Override Me
function BaseData:onCreate(...)
end

function BaseData:_init()
    g_BehaviorExtend(self)
end

function BaseData:onCleanup()
    self:unBindAllBehavior()
    self:onDestroy()
end

-- Override Me
function BaseData:onDestroy()
end

return BaseData