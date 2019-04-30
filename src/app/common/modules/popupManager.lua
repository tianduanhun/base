local PopupManager = class("PopupManager", function()
    return cc.Node:create()
end)

function PopupManager:ctor()
    self:setNodeEventEnabled(true)
    self.viewsInfo = {}
end

function PopupManager:onCleanup()
    self.viewsInfo = nil
end

function PopupManager.getInstance()
    local scene = display.getRunningScene()
    if not scene or scene._cname ~= "MainScene" then
        return
    end
    if not scene._popManager then
        local popManager = PopupManager.new()
        scene:add(popManager, scene.ZorderConfig.POPUP)
        scene._popManager = popManager
    end
    return scene._popManager
end

local function showView(viewsInfo)
    local flag = true
    local topView
    for i = #viewsInfo, 1, -1 do
        local viewInfo = viewsInfo[i]
        if flag then
            if topView then
                if topView.isKeep then
                    viewInfo.view:setVisible(true)
                else
                    viewInfo.view:setVisible(false)
                    flag = false
                end
            else
                viewInfo.view:setVisible(true)
            end
        else
            viewInfo.view:setVisible(false)
        end
        viewInfo.view:setLocalZOrder(i)
        topView = viewInfo
    end
end

--[[
    @desc: 
    author:{author}
    time:2019-02-25 15:35:46
    --@view:
	--@params: {
        isKeep: 是否保持底部弹窗，默认不保持
        priority: 优先级，默认为0
    }
    @return:
]]
function PopupManager.pushView(view, params)
    assert(view, "View is nil")
    params = checktable(params)
    params.priority = params.priority or 0
    local root = PopupManager.getInstance()
    if root and root.viewsInfo then
        if view.enterAction and type(view.enterAction) == "function" then
            view:enterAction()
        end

        local index = 1
        for i = #root.viewsInfo, 1, -1 do
            local viewInfo = root.viewsInfo[i]
            if viewInfo.priority <= params.priority then --小于等于弹窗优先级时，确定插入位置，同优先级的新弹窗总是在上面
                index = i + 1
                break
            end
        end
        params.view = view
        table.insert(root.viewsInfo, index, params)
        root:add(view)

        showView(root.viewsInfo)
        return view
    end
end

--[[
    @desc: 移除顶层弹窗
    author:BogeyRuan
    time:2019-04-30 17:57:27
    --@[target]: 可选参数，需要弹出的层
    @return:
]]
function PopupManager.popView(target)
    local root = PopupManager.getInstance()
    if root and root.viewsInfo then
        local index = #root.viewsInfo
        if target then
            for i, v in ipairs(target) do
                if v.view == target then
                    index = i
                    break
                end
            end
        end

        local viewInfo = table.remove(root.viewsInfo, index)
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
                        showView(root.viewsInfo)
                    end
                )
            )
        )
    end
end

return PopupManager
