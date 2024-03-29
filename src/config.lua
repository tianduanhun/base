
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- display FPS stats on screen
DEBUG_FPS = DEBUG > 0

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- design resolution
CONFIG_SCREEN_WIDTH  = 720
CONFIG_SCREEN_HEIGHT = 1280

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_AUTO"

-- use bytecode
USE_BYTECODE = false

-- use bugly
USE_BUGLY = false

-- cpu 32 or 64
CPU = "32"
if jit and jit.arch == "arm64" then
    CPU = "64"
end