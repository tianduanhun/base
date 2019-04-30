local MainScene = class("MainScene", function()
    return cc.Scene:create()
end)

MainScene.ZorderConfig = {
    VIEW = 1,
    POPUP = 2,
    ANIMATE = 3,
}

function MainScene:ctor()
    self:setNodeEventEnabled(true)
    self:init_()
    self:onCreate()
end

function MainScene:onCreate()
    self._ViewNode = cc.Node:create():addTo(self, self.ZorderConfig.VIEW)
    self._AniLayer = cc.Node:create():addTo(self, self.ZorderConfig.ANIMATE)
end

function MainScene:init_()
    g_BehaviorExtend(self)
end

function MainScene:onCleanup()
    self:unBindAllBehavior()
    self:onDestroy()
end

function MainScene:pushView(view)
    self._ViewNode:removeAllChildren()
    self._ViewNode:add(view)
end

return MainScene
