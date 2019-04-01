local ToastManager =class("ToastManager", function()
    return cc.Node:create()
end)

function ToastManager:ctor()
    self:setNodeEventEnabled(true)
    self.tips = {}
end

function ToastManager:onCleanup()
    self.tips = nil
end

function ToastManager.getInstance()
    local scene = display.getRunningScene()
    if not scene then
        return
    end
    if not scene._toastManager then
        local toastManager = ToastManager.new()
        scene:add(toastManager, g_NodeConfig.localZorder.toast)
        scene._toastManager = toastManager
    end
    return scene._toastManager
end

function ToastManager.pushToast(toast)
    if not toast or toast == "" then
        return
    end
    local root
    ToastManager.getInstance()
    if not root then
        return
    end
    if root.tips[#root.tips] == toast then
        return
    end
    table.insert(root.tips, toast)
    root:_showToast()
end

function ToastManager:_showToast()
    if self.isShowing then
        return
    end
    local str = table.remove(self.tips, 1)
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

return ToastManager
