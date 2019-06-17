local CURRENT_MODULE_NAME = ...
CURRENT_MODULE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6)

local dirs = {"event"}
for i, v in ipairs(dirs) do
    local module = import(CURRENT_MODULE_NAME .. "." .. v)
    for k, v in pairs(module) do
        _G["g_" .. string.upperFirst(k)] = v
    end
end
