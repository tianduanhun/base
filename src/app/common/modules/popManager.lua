local PopManager = class("PopManager", function()
    return cc.Node:create()
end)

function PopManager:ctor()
    self:setNodeEventEnabled(true)
    self.viewsInfo = {}
end

function PopManager:onCleanup()
    self.viewsInfo = nil
end

function PopManager.getInstance()
    local scene = display.getRunningScene()
    if not scene then
        return
    end
    if not scene._popManager then
        local popManager = PopManager.new()
        scene:add(popManager, g_NodeConfig.localZorder.pop)
        scene._popManager = popManager
    end
    return scene._popManager
end

--[[
    @desc: 
    author:{author}
    time:2019-02-25 15:35:46
    --@view:
	--@params: {isKeep, isTop}
    @return:
]]
function PopManager.pushView(view, params)
    assert(view, "View is nil")
    params = checktable(params)
    local root = PopManager.getInstance()
    if not root then
        return
    end
    if view.enterAction and type(view.enterAction) == "function" then
        view:enterAction()
    end

    if params.isTop or #root.viewsInfo == 0 then
        table.insert(root.viewsInfo, {view = view, isKeep = params.isKeep, isTop = params.isTop})
        root:add(view)
    else
        local index = 1
        for i = #root.viewsInfo, 1, -1 do
            local viewInfo = root.viewsInfo[i]
            if not viewInfo.isTop then
                index = i + 1
                break
            end
        end
        table.insert(root.viewsInfo, index, {view = view, isKeep = params.isKeep})
        root:add(view)
    end
    root.showView(root.viewsInfo)

    return view
end

function PopManager.showView(viewsInfo)
    local flag = true
    for i = #viewsInfo, 1, -1 do
        local viewInfo = viewsInfo[i]
        local topView = viewsInfo[i + 1]
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
    end
end

function PopManager.popView(tag)
    local root = PopManager.getInstance()
    if root.viewsInfo then
        local viewNum = #root.viewsInfo
        if viewNum > 0 then
            tag = math.max(1, math.min(viewNum, ((tonumber(tag) or viewNum - 1) + 1)))
            for i = viewNum, tag, -1 do
                local viewInfo = table.remove(root.viewsInfo, i)
                local view = viewInfo.view
                local delayTime = 0
                if type(view.exitAction) == "function" then
                    delayTime = view:exitAction()
                end
                view:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime), cc.CallFunc:create(function()
                    view:removeFromParent()
                end)))
            end
        end
    end
    local viewInfo = root.viewsInfo[#root.viewsInfo]
    if viewInfo then
        viewInfo.view:setVisible(true)
    end
end

return PopManager
