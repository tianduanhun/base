local BaseSocket = class("BaseSocket")
local SimpleTCP = _require("framework.SimpleTCP")
local pbConfig = require("pb.pbConfig")

local string = string

--包结构
--| P         K         G         | ver:1     | len:65535           | body:string |
--| 0101 0000 0100 1011 0100 0111 | 0000 0001 | 1111 1111 1111 1111 |...          |

local packHeadLen = 6           --包头长度
local packHeadPrefix = "PKG"    --包头前缀
local packVersion = 1           --包头版本

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

function BaseSocket:sendData(service, data)
    assert(service, "Service name must exist")
    local serviceData = g_PbManager.encode(service, data)
    local socketData = g_PbManager.encode(pbConfig.method.SOCKET, {service = service, body = serviceData})
    local dataLen = packHeadLen + string.len(socketData)
    if dataLen > 65535 then
        print("data is too long, max len is 2^16 - 1")
        return
    end
    socketData = table.concat({packHeadPrefix, string.numToAscii(packVersion, 1), string.numToAscii(dataLen, 2), socketData})
    print("send socket data", #socketData, socketData)
    self.tcp:send(socketData)
end

function BaseSocket:reConnect()
    self.receiveData = ""
    self.tcp:connect()
end

function BaseSocket:closeConnect()
    self.tcp:close()
end

---------------------------------------
function BaseSocket:_callback(event, data)
    if event == SimpleTCP.EVENT_DATA then
        print("socket data", #data, data)
        self:readData(data)
    elseif event == SimpleTCP.EVENT_CONNECTED then
        print("socket connected")
        g_PushCenter.pushEvent(g_Event.SOCKET.CONNECTED)
    elseif event == SimpleTCP.EVENT_CLOSED then
        print("socket closed")
        g_PushCenter.pushEvent(g_Event.SOCKET.CLOSED)
    elseif event == SimpleTCP.EVENT_FAILED then
        print("socket failed")
        g_PushCenter.pushEvent(g_Event.SOCKET.FAILED)
    end
end

local function checkDataPack(data)
    if #data < packHeadLen then                                                             --数据长度不够
        return false
    end
    local start = string.find(data, packHeadPrefix, 1)
    if start then                                                                           --找到包头
        data = string.sub(data, start)                                                      --去除包头之前可能存在的错误数据
        local ver = string.asciiToNum(string.sub(data, 4, 4))                               --包协议版本（可能之后存在不同包协议）
        local bodyLen = string.asciiToNum(string.sub(data, 5, packHeadLen))
        local body = string.sub(data, packHeadLen + 1, bodyLen)
        if bodyLen == #body + packHeadLen then
            return true, body, start
        end
    end
    return false
end

function BaseSocket:readData(data)
    data = self.receiveData .. data
    local bool, body, offset = checkDataPack(data)
    while bool do
        local socketData = g_PbManager.decode(pbConfig.method.SOCKET, body)                 --解包socket
        if not table.isEmpty(socketData) then                                               --如果有数据
            local serviceData = g_PbManager.decode(socketData.service, socketData.body)     --解包对应的服务数据
            g_PushCenter.pushEvent(socketData.service, serviceData)                         --派发事件和数据
        end
        data = string.sub(data, packHeadLen + #body + offset)                               --获取下一段数据
        bool, body, offset = checkDataPack(data)                                            --检测数据包
    end
    self.receiveData = data
end

return BaseSocket