local SocketManager = class("SocketManager")
local SimpleTCP = _require("framework.SimpleTCP")

SocketManager.EVENT_CONNECTED = "SocketManager.EVENT_CONNECTED"
SocketManager.EVENT_CLOSE = "SocketManager.EVENT_CLOSE"

function SocketManager:ctor()
end

function SocketManager:openConnect(host, port)
    if self.connect and (self.connect.stat == SimpleTCP.STAT_CONNECTING or self.connect.stat == SimpleTCP.STAT_CONNECTED) then
        return
    end
    local tcp = self.connect or SimpleTCP.new(host, port, handler(self, self._callback))
    tcp:connect()
    self.connect = tcp
end

function SocketManager:closeConnect()
    if self.connect then
        self.connect:close()
    end
end

function SocketManager:sendMsg(data)
    data = checktable(data)
    self.connect:send(data)
end

function SocketManager:receiveMsg(data)
    dump(data)
end

function SocketManager:_callback(event, data)
    if event == SimpleTCP.EVENT_DATA then
        self:receiveMsg(data)
    elseif event == SimpleTCP.EVENT_CONNECTED then
        g_PushCenter.pushEvent(self.EVENT_CONNECTED)
    elseif event == SimpleTCP.STAT_CLOSED or event == SimpleTCP.EVENT_FAILED then
        
    end
end

return SocketManager