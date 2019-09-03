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
    self._ViewLayer = cc.Node:create():addTo(self, self.ZorderConfig.VIEW)      --界面层
    self._PopupLayer = cc.Node:create():addTo(self, self.ZorderConfig.POPUP)    --弹窗层
    self._AniLayer = cc.Node:create():addTo(self, self.ZorderConfig.ANIMATE)    --动画层
    self._ToastLayer = cc.Node:create():addTo(self, self.ZorderConfig.TOAST)    --提示层
    self._ViewsInfo = {}
    self._Toasts = {}
end

function MainScene:init_()
    g_BehaviorExtend(self)
end

function MainScene:onEnter()
    g_SocketManager:doMethod("openConnect")
end

function MainScene:onCleanup()
    self:unBindAllBehavior()
end

function MainScene:pushScene(scene)
    self._ViewLayer:removeAllChildren()
    self._PopupLayer:removeAllChildren()
    self._ViewsInfo = {}
    self._ViewLayer:add(scene)
    self._ViewLayer:setVisible(true)
end

-------------------------------------------------POPUP START
function MainScene:_showView()
    local topView
    for i = #self._ViewsInfo, 1, -1 do
        local viewInfo = self._ViewsInfo[i]

        if viewInfo.isFull and not (topView and topView.isFull) then
            viewInfo.view:setVisible(true)
            topView = viewInfo
        else
            if topView and ((not topView.isKeep) or topView.isFull) then
                viewInfo.view:setVisible(false)
            else
                viewInfo.view:setVisible(true)
                topView = viewInfo
            end
        end

        viewInfo.view:setLocalZOrder(i)
    end
    self._ViewLayer:setVisible(not topView.isFull)
end

--[[
    @desc: 
    author:Bogey
    time:2019-02-25 15:35:46
    --@view:
	--@params: {
        priority: 优先级，默认为0
        isKeep: 是否保持底部弹窗，默认true
        isFull: 是否全屏，默认false
        isSingle: 是否在所有弹窗中只保留一份，默认true
    }
    @return:
]]
function MainScene:pushView(view, params)
    assert(view, "View is nil")
    params = checktable(params)
    params.priority = params.priority or 0
    params.isKeep = params.isKeep == nil and true or params.isKeep
    params.isSingle = params.isSingle == nil and true or params.isSingle
    if params.isSingle then
        self:popView(view)
    end

    if view.enterAction and type(view.enterAction) == "function" then
        view:enterAction()
    end

    local index = 1
    for i = #self._ViewsInfo, 1, -1 do
        local viewInfo = self._ViewsInfo[i]
        if viewInfo.priority <= params.priority then --小于等于弹窗优先级时，确定插入位置，同优先级的新弹窗总是在上面
            index = i + 1
            break
        end
    end
    params.view = view
    table.insert(self._ViewsInfo, index, params)
    self._PopupLayer:add(view)

    self:_showView()
    return view
end

--[[
    @desc: 移除顶层弹窗
    author:Bogey
    time:2019-04-30 17:57:27
    --@[target]: 可选参数，需要弹出的层
    @return:
]]
function MainScene:popView(target)
    local index = #self._ViewsInfo
    if index == 0 then
        return
    end
    if target then
        for i, v in ipairs(self._ViewsInfo) do
            if v.view.__cname == target.__cname then
                index = i
                break
            end
        end
    end

    local viewInfo = table.remove(self._ViewsInfo, index)
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

--[[
    @desc: 获取顶部弹窗
    author:Bogey
    time:2019-08-16 11:27:38
    @return:
]]
function MainScene:getTopView()
    if #self._ViewsInfo > 0 then
        return (self._ViewsInfo[#self._ViewsInfo]).view
    end
end

--[[
    @desc: 移除全部弹窗
    author:Bogey
    time:2019-08-16 11:32:22
    @return:
]]
function MainScene:popAllView()
    for i,v in ipairs(self._ViewsInfo) do
        if type(v.view.exitAction) == "function" then
            local delayTime = v.view:exitAction() or 0
            v.view:runAction(cc.Sequence:create(
                cc.DelayTime:create(delayTime),
                cc.CallFunc:create(function()
                    v.view:removeFromParent()
                end)
            ))
        else
            v.view:removeFromParent()
        end
    end
    self._ViewsInfo = {}
    self:_showView()
end
-------------------------------------------------POPUP ENDED


-------------------------------------------------TOAST START
function MainScene:_showToast()
    if self.isShowing then
        return
    end
    local str = table.remove(self._Toasts, 1)
    if not str then
        return
    end
    self.isShowing = true
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function()
            local text = ccui.Text:create()
            text:setString(str)
            text:setFontSize(28)
            text:addTo(self._ToastLayer):align(display.CENTER, display.cx, display.height / 3 * 2 + 50)
            text:runAction(cc.Sequence:create(
                cc.MoveTo:create(1.5, cc.p(display.cx, display.height / 3 * 2 - 50)),
                cc.CallFunc:create(function ()
                    text:removeFromParent(true)
                end)
            ))
            self.isShowing = false
            self:_showToast()
        end)
    ))
end

function MainScene:pushToast(toast)
    if not toast or string.trim(toast) == "" then
        return
    end
    -- if self._Toasts[#self._Toasts] == toast then  --短时间内压入相同toast，相同的被忽略
    --     return
    -- end
    table.insert(self._Toasts, toast)
    self:_showToast()
end
-------------------------------------------------TOAST ENDED

return MainScene
