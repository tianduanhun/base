local g_Event = {}

local eventId = 0
local function getUniqueId()
    eventId = eventId + 1
    return "Event_UniqueId_" .. eventId
end

g_Event.MODULENAME = {}
g_Event.MODULENAME.TEST = getUniqueId()

return g_Event