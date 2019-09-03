local BaseSocket = class("BaseSocket")
local SimpleTCP = _require("framework.SimpleTCP")
local string = string

--包结构
--| len:65535           | body:string |
--| 1111 1111 1111 1111 |...          |

local packHeadLen = 2           --包头长度

BaseSocket.exportFuncs = {
    "sendData",
    "reConnect",
    "closeConnect"
}

function BaseSocket:ctor(host, port)
    g_BehaviorExtend(self)
    self:bindBehavior(g_BehaviorMap.eventBehavior)

    self.receiveData = ""

    self.tcp = SimpleTCP.new(host, port, handler(self, self._callback))
    self.tcp:connect()
end

function BaseSocket:sendData(data)
    local dataLen = packHeadLen + string.len(data)
    if dataLen > 65535 then
        error("data is too long, max len is 65535(2^16 - 1")
        return
    end
    data = string.numToAscii(dataLen, 2) .. data
    self.tcp:send(data)
end

function BaseSocket:reConnect()
    self.receiveData = ""
    self.tcp:connect()
end

function BaseSocket:closeConnect()
    self.receiveData = ""
    self.tcp:close()
end

---------------------------------------
function BaseSocket:_callback(event, data)
    if event == SimpleTCP.EVENT_DATA then
        self:readData(data)
    elseif event == SimpleTCP.EVENT_CONNECTED then
        g_PushCenter.pushEvent(g_Event.SOCKET.CONNECTED)
    elseif event == SimpleTCP.EVENT_CLOSED then
        g_PushCenter.pushEvent(g_Event.SOCKET.CLOSED)
    elseif event == SimpleTCP.EVENT_FAILED then
        g_PushCenter.pushEvent(g_Event.SOCKET.FAILED)
    end
end

local function checkDataPack(data)
    if #data < packHeadLen then                                                             --数据长度不够
        return false
    end
    local bodyLen = string.asciiToNum(string.sub(data, 1, packHeadLen))
    local body = string.sub(data, packHeadLen + 1, bodyLen)
    if bodyLen == #body + packHeadLen then
        return true, body
    end
    return false
end

function BaseSocket:readData(data)
    data = self.receiveData .. data
    local bool, body = checkDataPack(data)
    while bool do
        g_PushCenter.pushEvent(g_Event.SOCKET.DATA, body)
        data = string.sub(data, packHeadLen + #body + 1)
        bool, body = checkDataPack(data)
    end
    self.receiveData = data
end

return BaseSocket