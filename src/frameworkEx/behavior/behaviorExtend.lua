local BehaviorExtend

BehaviorExtend = function(object)
    function object:bindBehavior(behavior)
        assert(behavior, "Behavior is nil")
        if not self._behaviorObjects then
            self._behaviorObjects = {}
        end
        local behaviorName = tostring(behavior)
        local behaviorObject = behavior.new()
        behaviorObject:bind(self)
        self._behaviorObjects[behaviorName] = behaviorObject
        return behaviorObject
    end

    function object:unBindBehavior(behavior)
        assert(behavior, "Behavior is nil")
        if self:isBindBehavior(behavior) then
            local behaviorName = tostring(behavior)
            local behaviorObject = self._behaviorObjects[behaviorName]
            behaviorObject:unBind(self)
            self._behaviorObjects[behaviorName] = nil
        end
    end

    function object:unBindAllBehavior()
        if self._behaviorObjects == nil then
            return
        end
        for behaviorName, behaviorObject in pairs(self._behaviorObjects) do
            behaviorObject:unBind(self)
            self._behaviorObjects[behaviorName] = nil
        end
        self._behaviorObjects = {}
    end

    function object:bindMethod(behavior, methodName)
        if not self._originMethods then
            self._originMethods = {}
        end
        local originMethod = self[methodName]
        if originMethod then
            self._originMethods[methodName] = originMethod
        end
        self[methodName] = handler(behavior, behavior[methodName])
    end

    function object:unBindMethod(behavior, methodName)
        if not self._originMethods then
            self._originMethods = {}
        end
        self[methodName] = nil
        if self._originMethods[methodName] then
            self[methodName] = self._originMethods[methodName]
            self._originMethods[methodName] = nil
        end
    end

    function object:callOriginMethod(methodName, ...)
        if not self._originMethods then
            self._originMethods = {}
        end
        local originMethod = self._originMethods[methodName]
        if originMethod and type(originMethod) == "function" then
            originMethod(self, ...)
        else
            error("Not such method name:" .. methodName)
        end
    end

    function object:isBindBehavior(behavior)
        if self._behaviorObjects and self._behaviorObjects[tostring(behavior)] then
            return true
        end
        return false
    end
end

return BehaviorExtend
