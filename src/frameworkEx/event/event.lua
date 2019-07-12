local g_Event = {}

local eventId = 0
function g_Event.getUniqueId()
    eventId = eventId + 1
    return "Event_UniqueId_" .. eventId
end

return g_Event