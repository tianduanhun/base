g_Event.SOCKET = {}
g_Event.SOCKET.CONNECTED = g_Event.getUniqueId()--socket连接上了
g_Event.SOCKET.CLOSED = g_Event.getUniqueId()   --socket关闭了
g_Event.SOCKET.FAILED = g_Event.getUniqueId()   --socket连接失败
g_Event.SOCKET.RECONNECT = g_Event.getUniqueId()--socket重连
g_Event.SOCKET.SECRET = g_Event.getUniqueId()   --socket连接失败