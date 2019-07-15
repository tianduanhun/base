local g_SocketManager = class("SocketManager")
local SimpleTCP = _require("framework.SimpleTCP")
local baeSocket = require("baseSocket")
local pbConfig = require("pb.pbConfig")

g_SocketManager.registerEvents = {
    [g_Event.SOCKET.CONNECTED] = "onConnected",
    [g_Event.SOCKET.CLOSED] = "onClosed",
    [g_Event.SOCKET.FAILED] = "onFailed",
    [pbConfig.method.HEARTBEAT] = "onHeartbeatResp"
}

g_SocketManager.exportFuncs = {
    "openConnect",
    "send",
    "reConnect"
}

function g_SocketManager:ctor()
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)
    self:registerEvent()

    self.sendCacheData = {}
    self.heartbeatIndex = 1
end

----------------------------------------------------------------
function g_SocketManager:openConnect(tag)
    if not self.connect then
        self.connect = baeSocket.new("www.baidu.com", 80)
    end
end

function g_SocketManager:send(service, data)
    table.insert(self.sendCacheData, {service = service, data = data})
    self:_send()
end

function g_SocketManager:reConnect()
    self.sendCacheData = {}
    if self.status == SimpleTCP.EVENT_FAILED then
        self.connect:doMethod("reConnect")
    elseif self.status == SimpleTCP.EVENT_CLOSED then
        self:openConnect()
    end
end

function g_SocketManager:startHeartbeat()
    self.heartbeatScheduler = g_Scheduler.scheduleGlobal(function ()
        self:send(pbConfig.method.HEARTBEAT, {index = self.heartbeatIndex})
    end, 10)
end
----------------------------------------------------------------
function g_SocketManager:_send()
    if #self.sendCacheData > 0 then        --发送数据缓存里存在数据
        if self.status == SimpleTCP.EVENT_CONNECTED then
            local data = table.remove(self.sendCacheData, 1)
            self.connect:doMethod("sendData", data.service, data.data)
        end
        self:_send()
    end
end

function g_SocketManager:onConnected()
    self.status = SimpleTCP.EVENT_CONNECTED
    self:startHeartbeat()
    self:_send()
end

function g_SocketManager:onClosed()
    self.status = SimpleTCP.EVENT_CLOSED
    self.connect = nil
    if self.heartbeatScheduler then
        g_Scheduler.unscheduleGlobal(self.heartbeatScheduler)
        self.heartbeatScheduler = nil
    end
end

function g_SocketManager:onFailed()
    self.status = SimpleTCP.EVENT_FAILED
    if self.heartbeatScheduler then
        g_Scheduler.unscheduleGlobal(self.heartbeatScheduler)
        self.heartbeatScheduler = nil
    end
end

function g_SocketManager:onHeartbeatResp(data)
    data = checktable(data)
    if data.code == 0 then
        if self.heartbeatIndex ~= data.index then
            print("heartbeat have a mistake")
        end
        self.heartbeatIndex = data.index + 1
    end
end

return g_SocketManager