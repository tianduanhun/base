local BaseCtr = class("BaseCtr")

BaseCtr.registerEvents = {}
BaseCtr.exportFuncs = {}

function BaseCtr:ctor(_UI, ...)
    self._UI = _UI
    self._dataModules = {}

    self:_init()
    self:onCreate(...)
end

-- Override Me
function BaseCtr:onCreate(...)
    error("Must override the onCreate method")
end

function BaseCtr:_init()
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)
    self:registerEvent()
end

function BaseCtr:onCleanup()
    self._UI = nil
    self:unRegisterEvent()
    self:unBindAllDataSource()
    self:unBindAllBehavior()
    self:onDestroy()
end

-- Override Me
function BaseCtr:onDestroy()
end

function BaseCtr:_handler(methodName, ...)
    if methodName and self[methodName] then
        return self[methodName](self, ...)
    else
        print(self.__cname, methodName .. " method does not exist")
    end
end

-- 执行UI内的方法
function BaseCtr:doView(methodName, ...)
    if self._UI and self._UI._handler then
        return self._UI:_handler(methodName, ...)
    end
end

-- 绑定数据模块，绑定之后在整个模块内都可以使用
function BaseCtr:bindDataModule(moduleName)
    local dataModule = g_App:getDataModule(moduleName)

    moduleName =  string.upperFirst(moduleName)
    local env = getfenv(self.onCreate)
    env[moduleName .. "Config"] = dataModule.getConfig()
    env[moduleName .. "Interface"] = dataModule.getData()
    self._dataModules[moduleName] = {moduleName .. "Config", moduleName .. "Interface"}

    env[moduleName .. "Interface"]:doMethodByKey("bind", self)
end

function BaseCtr:unBindAllDataSource()
    local env = getfenv(self.onCreate)
    for k,v in pairs(self._dataModules) do
        if env[v[2]] and env[v[2]].doMethodByKey then
            env[v[2]]:doMethodByKey("unBind", self)
        end
        env[v[1]] = nil
        env[v[2]] = nil
    end
    self._dataModules = {}
end

return BaseCtr
