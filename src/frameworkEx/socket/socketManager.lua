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
    "reConnect",
    "closeConnect"
}

local HEARTBEAT_TIME = 10       --心跳间隔时间
local RECONNECT_TIMES = 1       --重连次数

function g_SocketManager:ctor()
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)
    self:registerEvent()

    self.sendCacheData = {}     --发送数据缓存
    self.heartbeatIndex = 1     --心跳索引
    self:initParams()
end

function g_SocketManager:initParams()
    self.reconnectTimes = 0     --自动重连次数
    self.reconnectStatus = true --是否自动重连
end

----------------------------------------------------------------
function g_SocketManager:openConnect(tag)
    if self.connect then
        self:autoCloseConnect(false)
        self.connect = nil
    end
    self.connect = baeSocket.new("localhost", 1234)
end

function g_SocketManager:send(service, data)
    table.insert(self.sendCacheData, {service = service, data = data})
    self:autoSend()
end

function g_SocketManager:reConnect()
    self.sendCacheData = {}
    if self.status == SimpleTCP.EVENT_FAILED or self.status == SimpleTCP.EVENT_CLOSED then
        self.connect:doMethod("reConnect")
    end
end

function g_SocketManager:closeConnect()
    self:autoCloseConnect(false)
end

----------------------------------------------------------------

function g_SocketManager:autoSend()
    if #self.sendCacheData > 0 then        --发送数据缓存里存在数据
        if self.status == SimpleTCP.EVENT_CONNECTED then
            local data = table.remove(self.sendCacheData, 1)
            self.connect:doMethod("sendData", data.service, data.data)
        end
        self:autoSend()
    end
end

function g_SocketManager:autoStartHeartbeat()
    self.heartbeatStatus = true
    self.heartbeatScheduler = g_Scheduler.scheduleGlobal(function ()
        if not self.heartbeatStatus then    --上一条心跳没收到回复
            self:autoCloseConnect(true)
            return
        end
        self.heartbeatStatus = false
        self:send(pbConfig.method.HEARTBEAT, {index = self.heartbeatIndex})
    end, HEARTBEAT_TIME)
end

function g_SocketManager:autoStopHeartbeat()
    if self.heartbeatScheduler then
        g_Scheduler.unscheduleGlobal(self.heartbeatScheduler)
        self.heartbeatScheduler = nil
    end
end

function g_SocketManager:autoReConnect()
    if not self.reconnectStatus then
        return
    end
    if self.reconnectTimes >= RECONNECT_TIMES then
        g_PushCenter.pushEvent(g_Event.SOCKET.RECONNECT, false)
        return
    end
    self.reconnectTimes = self.reconnectTimes + 1
    g_PushCenter.pushEvent(g_Event.SOCKET.RECONNECT, self.reconnectTimes)
    self:reConnect()
end

function g_SocketManager:autoCloseConnect(bool)
    self.reconnectStatus = bool
    if self.status == SimpleTCP.EVENT_CONNECTED then
        self.connect:doMethod("closeConnect")
    end
end

-----------------------------------------------------------

function g_SocketManager:onConnected()
    self.status = SimpleTCP.EVENT_CONNECTED
    self:initParams()
    self:autoStartHeartbeat()
    self:autoSend()
end

function g_SocketManager:onClosed()
    self.status = SimpleTCP.EVENT_CLOSED
    self:autoStopHeartbeat()
    self:autoReConnect()
end

function g_SocketManager:onFailed()
    self.status = SimpleTCP.EVENT_FAILED
    self:autoStopHeartbeat()
    self:autoReConnect()
end

function g_SocketManager:onHeartbeatResp(data)
    data = checktable(data)
    if data.code == 0 then
        if self.heartbeatIndex ~= data.index then
            print("heartbeat have a mistake")
        end
        self.heartbeatIndex = data.index + 1
        self.heartbeatStatus = true
    end
end

return g_SocketManager