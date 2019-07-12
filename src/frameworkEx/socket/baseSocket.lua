local BaseSocket = class("BaseSocket")
local SimpleTCP = _require("framework.SimpleTCP")
local pbConfig = require("pb.pbConfig")

local string = string

--包结构
--| B         O         G         | ver:1     | len:65535           | body:string |
--| 0100 0010 0100 1111 0100 0111 | 0011 0001 | 1111 1111 1111 1111 |...          |

local packHeadLen = 7   --包头长度
local packHead = "BOG"  --包头前缀
local packVersion = 1   --包头版本

BaseSocket.exportFuncs = {
    "sendData",
    "reConnect"
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
        error("data is too long")
    end
    socketData = packHead .. string.numToAscii(packVersion) .. string.numToAscii(dataLen) .. socketData
    self.tcp:send(socketData)
end

function BaseSocket:reConnect()
    self.receiveData = ""
    self.tcp:connect()
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
        local ver = string.asciiToNum(string.sub(data, 4, 4))                               --校验包头版本
        if ver ~= packVersion then
            g_PushCenter.pushEvent(g_Event.SOCKET.UPDATE)
            return false
        end
        local bodyLen = string.asciiToNum(string.sub(data, 5, 6))                           --从消息中获取包体长度
        local body = string.sub(data, 7)
        if bodyLen == #body + packHeadLen then                                              --数据包完整
            return true, body
        end
    end
    return false
end

function BaseSocket:readData(data)
    data = self.receiveData .. data                                                         --连接之前暂存的数据
    local bool, body = checkDataPack(data)
    while bool do
        local socketData = g_PbManager.decode(pbConfig.method.SOCKET, body)                 --解包socket
        if not table.isEmpty(socketData) then                                               --如果有数据
            local serviceData = g_PbManager.decode(socketData.service, socketData.body)     --解包对应的服务数据
            g_PushCenter.pushEvent(socketData.service, serviceData)                         --派发事件和数据
        end
        data = string.sub(data, packHeadLen + #body + 1)                                    --获取下一段数据
        bool, body = checkDataPack(data)                                                    --检测数据包
    end
    if string.find(data, packHead, 1, 3) then                                               --判断剩下的数据是否是包头开始的
        self.receiveData = data                                                             --是正常的数据则保存
    else
        self.receiveData = ""                                                               --不是正常的数据则清空
    end
end

return BaseSocket