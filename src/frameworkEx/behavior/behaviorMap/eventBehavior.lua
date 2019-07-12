local EventBehavior = class("EventBehavior", g_BehaviorBase)

EventBehavior.exportFuncs = {
    "registerEvent",
    "unRegisterEvent",
    "doMethod"
}

function EventBehavior:registerEvent(object)
    local events = checktable(object.registerEvents)
    for k, v in pairs(events) do
        if object[v] and type(object[v]) == "function" then
            g_PushCenter.addListener(k, handler(object, object[v]), object)
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
    local funcs = checktable(object.exportFuncs)
    if isPublicMethod(funcs, methodName) then
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
