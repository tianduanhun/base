local ToastManager = class("ToastManager", function()
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
    local node = cc.Director:getInstance():getNotificationNode()
    if not node then
        node = ToastManager.new()
        cc.Director:getInstance():setNotificationNode(node)
    end
    return node
end

function ToastManager.pushToast(toast)
    if not toast or toast == "" then
        return
    end
    local root = ToastManager.getInstance()
    if not root then
        return
    end
    if root.tips[#root.tips] == toast then  --短时间内压入相同toast，相同的被忽略
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
