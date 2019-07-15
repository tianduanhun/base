--组件基类，所有组件必须继承该类
---组件基类
local BaseBehavior = class("BaseBehavior")

BaseBehavior.exportFuncs = {}

--组件绑定对象
function BaseBehavior:bind(object)
    for i,v in ipairs(self.exportFuncs) do
        object:bindMethod(self, v)
    end
end

--组件解绑对象
function BaseBehavior:unBind(object)
    for i,v in ipairs(self.exportFuncs) do
        object:unBindMethod(self, v)
    end
end

return BaseBehavior
