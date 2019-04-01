--组件基类，所有组件必须继承该类
---组件基类
local BehaviorBase = class("BehaviorBase")

BehaviorBase.exportFuncs = {}

--组件绑定对象
function BehaviorBase:bind(object)
    for i,v in ipairs(self.exportFuncs) do
        object:bindMethod(self, v)
    end
end

--组件解绑对象
function BehaviorBase:unBind(object)
    for i,v in ipairs(self.exportFuncs) do
        object:unBindMethod(self, v)
    end
end

return BehaviorBase
