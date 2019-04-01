local CURRENT_MODULE_NAME = ...
CURRENT_MODULE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6)

-- 全局变量
require(CURRENT_MODULE_NAME .. ".global.globalFunction")
local globalMap = require(CURRENT_MODULE_NAME .. ".global.globalMap")
globalMap:init(CURRENT_MODULE_NAME)