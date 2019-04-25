local BaseScene = class("BaseScene", function()
    return cc.Scene:create()
end)

function BaseScene:ctor()
    self:setNodeEventEnabled(true)
    self:init_()
    self:onCreate()
end

function BaseScene:onCreate()
    self._ViewNode = cc.Node:create():addTo(self)
    self._AniLayer = cc.Node:create():addTo(self, 1)
end

function BaseScene:init_()
    g_BehaviorExtend(self)
end

function BaseScene:onCleanup()
    self:unBindAllBehavior()
    self:onDestroy()
end

function BaseScene:pushView(view)
    self._ViewNode:removeAllChildren()
    self._ViewNode:add(view)
end

return BaseScene
