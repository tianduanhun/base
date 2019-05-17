local MainScene = class("MainScene", function()
    return cc.Scene:create()
end)

MainScene.ZorderConfig = {
    VIEW = 1,
    POPUP = 2,
    ANIMATE = 3,
    TOAST = 4
}

function MainScene:ctor()
    self:setNodeEventEnabled(true)
    self:init_()
    self:onCreate()
end

function MainScene:onCreate()
    self._ViewLayer = cc.Node:create():addTo(self, self.ZorderConfig.VIEW)
    self._PopupLayer = cc.Node:create():addTo(self, self.ZorderConfig.POPUP)
    self._AniLayer = cc.Node:create():addTo(self, self.ZorderConfig.ANIMATE)
    self._ToastLayer = cc.Node:create():addTo(self, self.ZorderConfig.TOAST)
    self.viewsInfo = {}
    self.toasts = {}
end

function MainScene:init_()
    g_BehaviorExtend(self)
end

function MainScene:onCleanup()
    self:unBindAllBehavior()
    self:onDestroy()
end

function MainScene:pushScene(scene)
    self._ViewLayer:removeAllChildren()
    self._PopupLayer:removeAllChildren()
    self.viewsInfo = {}
    self._ViewLayer:add(scene)
    self._ViewLayer:setVisible(true)
end

-------------------------------------------------POPUP START
function MainScene:_showView()
    local topView
    for i = #self.viewsInfo, 1, -1 do
        local viewInfo = self.viewsInfo[i]

        if topView and ((not topView.isKeep) or (topView.isFull)) then
            viewInfo.view:setVisible(false)
        else
            viewInfo.view:setVisible(true)
            topView = viewInfo
        end

        viewInfo.view:setLocalZOrder(i)
    end
    if topView then
        self._ViewLayer:setVisible(not topView.isFull)
    else
        self._ViewLayer:setVisible(true)
    end
end

--[[
    @desc: 
    author:{author}
    time:2019-02-25 15:35:46
    --@view:
	--@params: {
        priority: 优先级，默认为0
        isKeep: 是否保持底部弹窗，默认false
        isFull: 是否是全屏的界面，优化drawcall，默认false
    }
    @return:
]]
function MainScene:pushView(view, params)
    assert(view, "View is nil")
    params = checktable(params)
    params.priority = params.priority or 0

    if view.enterAction and type(view.enterAction) == "function" then
        view:enterAction()
    end

    local index = 1
    for i = #self.viewsInfo, 1, -1 do
        local viewInfo = self.viewsInfo[i]
        if viewInfo.priority <= params.priority then --小于等于弹窗优先级时，确定插入位置，同优先级的新弹窗总是在上面
            index = i + 1
            break
        end
    end
    params.view = view
    table.insert(self.viewsInfo, index, params)
    self._PopupLayer:add(view)

    self:_showView()
    return view
end

--[[
    @desc: 移除顶层弹窗
    author:BogeyRuan
    time:2019-04-30 17:57:27
    --@[target]: 可选参数，需要弹出的层
    @return:
]]
function MainScene:popView(target)
    local index = #self.viewsInfo
    if index == 0 then
        return
    end
    if target then
        for i, v in ipairs(target) do
            if v.view == target then
                index = i
                break
            end
        end
    end

    local viewInfo = table.remove(self.viewsInfo, index)
    local view = viewInfo.view
    local delayTime = 0
    if type(view.exitAction) == "function" then
        delayTime = view:exitAction() or 0
    end
    view:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(delayTime),
            cc.CallFunc:create(
                function()
                    view:removeFromParent()
                    self:_showView()
                end
            )
        )
    )
end
-------------------------------------------------POPUP ENDED


-------------------------------------------------TOAST START
function MainScene:_showToast()
    if self.isShowing then
        return
    end
    local str = table.remove(self.toasts, 1)
    if not str then
        return
    end
    self.isShowing = true
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
            print(str)
            self.isShowing = false
            self:_showToast()
        end)
    ))
end

function MainScene:pushToast(toast)
    if not toast or string.trim(toast) == "" then
        return
    end
    if self.toasts[#self.toasts] == toast then  --短时间内压入相同toast，相同的被忽略
        return
    end
    table.insert(self.toasts, toast)
    self:_showToast()
end
-------------------------------------------------TOAST ENDED

return MainScene
