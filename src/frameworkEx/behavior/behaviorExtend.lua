local BehaviorExtend

BehaviorExtend = function(object)
    function object:bindBehavior(behavior)
        assert(behavior, "Behavior is nil")
        if not self.behaviorObjects_ then
            self.behaviorObjects_ = {}
        end
        local behaviorName = tostring(behavior)
        local behaviorObject = behavior.new()
        behaviorObject:bind(self)
        self.behaviorObjects_[behaviorName] = behaviorObject
        return behaviorObject
    end

    function object:unBindBehavior(behavior)
        assert(behavior, "Behavior is nil")
        local behaviorName = tostring(behavior)
        assert(self.behaviorObjects_ and self.behaviorObjects_[behaviorName], "Behavior is Not Binding")
        local behaviorObject = self.behaviorObjects_[behaviorName]
        behaviorObject:unBind(self)
        self.behaviorObjects_[behaviorName] = nil
    end

    function object:unBindAllBehavior()
        if self.behaviorObjects_ == nil then
            return
        end
        for behaviorName, behaviorObject in pairs(self.behaviorObjects_) do
            behaviorObject:unBind(self)
            self.behaviorObjects_[behaviorName] = nil
        end
        self.behaviorObjects_ = {}
    end

    function object:bindMethod(behavior, methodName)
        if not self.originMethods_ then
            self.originMethods_ = {}
        end
        local originMethod = self[methodName]
        if originMethod then
            self.originMethods_[methodName] = originMethod
        end
        self[methodName] = handler(behavior, behavior[methodName])
    end

    function object:unBindMethod(behavior, methodName)
        if not self.originMethods_ then
            self.originMethods_ = {}
        end
        self[methodName] = nil
        if self.originMethods_[methodName] then
            self[methodName] = self.originMethods_[methodName]
            self.originMethods_[methodName] = nil
        end
    end

    function object:callOriginMethod(methodName, ...)
        if not self.originMethods_ then
            self.originMethods_ = {}
        end
        local originMethod = self.originMethods_[methodName]
        if originMethod and type(originMethod) == "function" then
            originMethod(self, ...)
        else
            error("Not such method name:" .. methodName)
        end
    end
end

return BehaviorExtend
