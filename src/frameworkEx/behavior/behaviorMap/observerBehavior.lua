local ObserverBehavior = class("ObserverBehavior", g_BaseBehavior)

ObserverBehavior.exportFuncs = {
    "addObserver",
    "removeObserver",
    "notifyObserver",
    "setNotifyFuncName",
    "removeAllObserver"
}

function ObserverBehavior:ctor()
    self.observerList = {}
    setmetatable(self.observerList, {__mode = "kv"})
    self.notifyFuncName = "onObserverNotify"

    self.isNotifying = false
    self.needDeleteObserver = {}
    setmetatable(self.needDeleteObserver, {__mode = "kv"})
end

function ObserverBehavior:addObserver(object, observer)
    assert(observer[self.notifyFuncName], string.format("%s must implement the '%s' method", observer.__cname, self.notifyFuncName))
    self.observerList[observer] = true
end

function ObserverBehavior:removeObserver(object, observer)
    if self.isNotifying then
        self.needDeleteObserver[observer] = true
    else
        self.observerList[observer] = nil
    end
end

function ObserverBehavior:notifyObserver(object, ...)
    self.isNotifying = true
    for k, _ in pairs(self.observerList) do
        if k[self.notifyFuncName] and not self.needDeleteObserver[k] then
            k[self.notifyFuncName](k, ...)
        end
    end
    self.isNotifying = false

    for k, v in pairs(self.needDeleteObserver) do
        self.observerList[k] = nil
        self.needDeleteObserver[k] = nil
    end
end

function ObserverBehavior:setNotifyFuncName(object, name)
    self.notifyFuncName = name
end

function ObserverBehavior:removeAllObserver(object)
    for k, _ in pairs(self.observerList) do
        self.observerList[k] = nil
    end
end

return ObserverBehavior
