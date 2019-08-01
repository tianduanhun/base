g_PbManager = require("pbManager")
require("config.event")
local init = {
    pbManager = g_PbManager,
    socketManager = require("socketManager").new(),
}
return init