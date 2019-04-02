local BaseScene = class("BaseScene", function()
    return cc.Scene:create()
end)

function BaseScene:ctor()
    self:setNodeEventEnabled(true)
    self:init_()
    self:onCreate()
end

function BaseScene:onCreate()
    self._viewNode = cc.Node:create():addTo(self)
    self._aniLayer = cc.Node:create():addTo(self, 1)
end

function BaseScene:init_()
    g_BehaviorExtend(self)
end

function BaseScene:onCleanup()
    self:unBindAllBehavior()
    self:onDestroy()
end

function BaseScene:pushView(view)
    --@TODO 2019-04-02 17:17:30 切换场景动画
    self._viewNode:removeAllChildren()
    self._viewNode:add(view)
end

return BaseScene
