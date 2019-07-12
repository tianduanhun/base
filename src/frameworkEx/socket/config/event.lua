g_Event.SOCKET = {}
g_Event.SOCKET.CONNECTED = g_Event.getUniqueId()--socket连接上了
g_Event.SOCKET.CLOSED = g_Event.getUniqueId()   --socket关闭了
g_Event.SOCKET.FAILED = g_Event.getUniqueId()   --socket连接失败
g_Event.SOCKET.UPDATE = g_Event.getUniqueId()   --数据协议版本对不上