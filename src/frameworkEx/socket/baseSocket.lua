local BaseSocket = class("BaseSocket")
local SimpleTCP = _require("framework.SimpleTCP")
local pbConfig = require("pb.pbConfig")

local string = string

--包结构
--| P         K         G         | ver:1     | len:65535           | body:string |
--| 0101 0000 0100 1011 0100 0111 | 0000 0001 | 1111 1111 1111 1111 |...          |

local packHeadLen = 6   --包头长度
local packHead = "PKG"  --包头前缀
local packVersion = 1   --包头版本

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
    socketData = table.concat(packHead, string.numToAscii(packVersion, 1), string.numToAscii(dataLen, 2), socketData)
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
    if #data > packHeadLen and string.find(data, packHead, 1, 3) then                       --找到包头，但是数据可能不完整
        local ver = string.asciiToNum(string.sub(data, 4, 4))                               --获取包头版本
        local bodyLen = string.asciiToNum(string.sub(data, 5, packHeadLen))                 --从消息中获取包体长度
        local body = string.sub(data, packHeadLen + 1)
        if bodyLen == #body + packHeadLen then                                              --数据包完整
            return true, body
        end
    end
    return false
end

function BaseSocket:readData(data)
    local tempData = self.receiveData .. data                                               --之前的数据可能存在错误，先检查下
    local bool, body = checkDataPack(tempData)
    if bool then
        data = tempData
    else
        bool, body = checkDataPack(data)
    end
    while bool do
        local socketData = g_PbManager.decode(pbConfig.method.SOCKET, body)                 --解包socket
        if not table.isEmpty(socketData) then                                               --如果有数据
            local serviceData = g_PbManager.decode(socketData.service, socketData.body)     --解包对应的服务数据
            g_PushCenter.pushEvent(socketData.service, serviceData)                         --派发事件和数据
        end
        data = string.sub(data, packHeadLen + #body + 1)                                    --获取下一段数据
        bool, body = checkDataPack(data)                                                    --检测数据包
    end
    self.receiveData = data
end

return BaseSocket