local g_SocketManager = class("SocketManager")
local SimpleTCP = _require("framework.SimpleTCP")
local pbConfig = require("pb.pbConfig")

g_SocketManager.registerEvents = {
    [g_Event.SOCKET.CONNECTED] = "onConnected",
    [g_Event.SOCKET.CLOSED] = "onClosed",
    [g_Event.SOCKET.FAILED] = "onFailed",
    [g_Event.SOCKET.DATA] = "onData",
    [pbConfig.method.HEARTBEAT] = "onHeartbeatResp"
}

g_SocketManager.exportFuncs = {
    "openConnect",
    "send",
    "reConnect",
    "closeConnect",
    "bindUser"
}

local connectStatus = {
    NORMAL = 1,
    RECONNECT = 2
}

local HEARTBEAT_TIME = 15       --心跳间隔时间
local RECONNECT_TIMES = 3       --重连次数

function g_SocketManager:ctor()
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)
    self:registerEvent()

    self.sendCacheData = {}                     --发送数据缓存
    self.connectStatus = connectStatus.NORMAL   --连接状态

    self:initParams()
end

function g_SocketManager:initParams()
    self.heartbeatIndex = 1     --心跳索引
    self.reconnectTimes = 0     --自动重连次数
    self.isAutoReconnect = true --是否自动重连
    self.socketSecret = ""      --校验密钥
end

----------------------------------------------------------------
function g_SocketManager:openConnect(tag)
    if self.connect then
        self:autoCloseConnect(false)
        self.connect = nil
    end
    self.connect = g_BaseSocket.new("192.168.220.130", 8888)
end

function g_SocketManager:send(service, data)
    assert(service, "Service name must exist")
    local serviceData = g_PbManager.encode(service, data)
    local socketData = g_PbManager.encode(pbConfig.method.SOCKET, {service = service, body = serviceData})
    table.insert(self.sendCacheData, socketData)
    self:autoSend()
end

function g_SocketManager:reConnect()
    if self.status == SimpleTCP.EVENT_FAILED or self.status == SimpleTCP.EVENT_CLOSED then
        self.connectStatus = connectStatus.RECONNECT
        self.connect:doMethod("reConnect")
    end
end

function g_SocketManager:closeConnect()
    self:autoCloseConnect(false)
end

function g_SocketManager:bindUser(uid)
    self.userId = uid
end

----------------------------------------------------------------

function g_SocketManager:autoSend()
    if self.status == SimpleTCP.EVENT_CONNECTED and #self.sendCacheData > 0 then        --发送数据缓存里存在数据
        local data = table.remove(self.sendCacheData, 1)
        self.connect:doMethod("sendData", data)
        self:autoSend()
    end
end

function g_SocketManager:autoStartHeartbeat()
    -- self.heartbeatStatus = true
    -- self.heartbeatScheduler = g_Scheduler.scheduleGlobal(function ()
    --     if not self.heartbeatStatus then    --上一条心跳没收到回复
    --         self:autoCloseConnect(true)
    --         return
    --     end
    --     self.heartbeatStatus = false
    --     self:send(pbConfig.method.HEARTBEAT, {index = self.heartbeatIndex})
    -- end, HEARTBEAT_TIME)
end

function g_SocketManager:autoStopHeartbeat()
    if self.heartbeatScheduler then
        g_Scheduler.unscheduleGlobal(self.heartbeatScheduler)
        self.heartbeatScheduler = nil
    end
end

function g_SocketManager:autoReConnect()
    if not self.isAutoReconnect then    --属于服务器或客户端主动断开连接
        self:initParams()
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
    self.isAutoReconnect = bool
    if self.status == SimpleTCP.EVENT_CONNECTED then
        self.connect:doMethod("closeConnect")
    end
end

-----------------------------------------------------------

function g_SocketManager:onConnected()
    if self.connectStatus == connectStatus.RECONNECT and self.userId and self.socketSecret then
        local serviceData = g_PbManager.encode(pbConfig.method.RECONNECT, {uid = self.userId, secret = self.socketSecret})
        local socketData = g_PbManager.encode(pbConfig.method.SOCKET, {service = pbConfig.method.RECONNECT, body = serviceData})
        table.insert(self.sendCacheData, 1, socketData)
        self.connectStatus = connectStatus.NORMAL
    end

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

function g_SocketManager:onData(data)
    local socketData = g_PbManager.decode(pbConfig.method.SOCKET, data)
    if not table.isEmpty(socketData) then
        if socketData.code == 0 then
            if not string.isEmpty(socketData.secret) then
                self.socketSecret = socketData.secret
            end
            local serviceData = g_PbManager.decode(socketData.service, socketData.body)
            g_PushCenter.pushEvent(socketData.service, serviceData)
        else
            print("Socket Error, Code: " .. socketData.code)
        end
    end
end

function g_SocketManager:onHeartbeatResp(data)
    data = checktable(data)
    if data.code == 0 then
        if data.index == 0 then
            self:closeConnect()
            return
        end
        self.heartbeatIndex = data.index + 1
        self.heartbeatStatus = true
    end
end

return g_SocketManager