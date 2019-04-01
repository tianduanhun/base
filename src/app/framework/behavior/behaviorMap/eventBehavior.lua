local EventBehavior = class("EventBehavior", g_BehaviorBase)

EventBehavior.exportFuncs = {
    "registerEvent",
    "unRegisterEvent",
    "doMethod"
}

function EventBehavior:registerEvent(object)
    for k, v in pairs(object.registerEvents) do
        if object[v] and type(object[v]) == "function" then
            g_PushCenter.addListener(k, handler(object, v), object)
        end
    end
end

function EventBehavior:unRegisterEvent(object)
    g_PushCenter.removeListenersByTag(object)
end

local function isPublicMethod(methods, methodName)
    for k, v in pairs(methods) do
        if v == methodName then
            return true
        end
    end
end

function EventBehavior:doMethod(object, methodName, ...)
    if isPublicMethod(object.exportFuncs, methodName) then
        if object[methodName] then
            return object[methodName](object, ...)
        else
            error(methodName .. " is not exist")
        end
    else
        error(methodName .. "is private method")
    end
end

return EventBehavior
