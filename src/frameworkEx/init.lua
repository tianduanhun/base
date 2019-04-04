local CURRENT_MODULE_NAME = ...
CURRENT_MODULE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6)

_require = clone(require)
-- 记录加载的模块
local importModules = {}

local FileUtils = cc.FileUtils:getInstance()
local function loadLuaScript(path)
    path = string.gsub(path, "%.", "/")
    local ext = {".lua", ".luac"}
    for i, v in ipairs(ext) do
        local fullPath = FileUtils:fullPathForFilename("src/" .. path .. v)
        if FileUtils:isFileExist(fullPath) then
            local data = FileUtils:getStringFromFile(fullPath)
            return loadstring(data, fullPath)
        end
    end
end

function import(path)
    assert(path and path ~= "", "The path is empty")
    path = string.gsub(path, "%.", "/")
    local result = package.loaded[path]
    if not result then
        local env = {}
        env.getPath = function()
            return path .. "/"
        end
        local function require(path)
            path = string.gsub(path, "%.", "/")
            path = env.getPath() .. path
            local result = package.loaded[path]
            if not result then
                local loadFunc = loadLuaScript(path)
                if type(loadFunc) ~= "function" then
                    error("Loading file error : " .. path)
                end
                setfenv(loadFunc, env)
                result = loadFunc()
                package.loaded[path] = result
                importModules[path] = true
            end
            return result
        end
        local loadFunc = loadLuaScript(path .. "/init")
        if type(loadFunc) ~= "function" then
            error("Loading file error : " .. path)
        end
        setmetatable(
            env,
            {
                __index = function(tb, key)
                    if key == "require" then
                        return require
                    else
                        return _G[key]
                    end
                end
            }
        )
        setfenv(loadFunc, env)
        result = loadFunc()
        package.loaded[path] = result
        importModules[path] = true
    end
    return result
end

function unimport(path)
    assert(path and path ~= "", "The path is empty")
    path = string.gsub(path, "%.", "/")

    local temp = {}
    local pathLen = string.len(path)
    for k, _ in pairs(importModules) do
        local key = string.gsub(k, "%.", "/")
        if string.sub(key, 1, pathLen) == path then
            importModules[key] = nil
            table.insert(temp, key)
        end
    end
    table.sort(
        temp,
        function(a, b)
            return string.len(a) < string.len(b)
        end
    )
    for i, v in ipairs(temp) do
        if package.loaded[v]._DESTROY and type(package.loaded[v]._DESTROY) == "function" then
            package.loaded[v]._DESTROY()
        end
        package.loaded[v] = nil
    end
end

-- 加载自定义框架
-- 工具类
local utils = import(CURRENT_MODULE_NAME .. ".utils")
g_FileUtils = utils.fileUtils

-- 库类
local lib = import(CURRENT_MODULE_NAME .. ".lib")
-- g_Delaunay = lib.delaunay

-- 事件类
local event = import(CURRENT_MODULE_NAME .. ".event")
g_PushCenter = event.pushCenter

-- 数据存储类
local database = import(CURRENT_MODULE_NAME .. ".database")
g_Db = database.db
g_Dict = database.dict

-- protobuf类
-- local pb = import(CURRENT_MODULE_NAME .. ".pb")
-- g_PbManager = pb.pbManager

-- socket类
-- local socket = import(CURRENT_MODULE_NAME .. ".socket")
-- g_SocketManager = socket.socketManager

-- cocos方法扩展
local extend = import(CURRENT_MODULE_NAME .. ".extend")

-- 组件基础类
local behavior = import(CURRENT_MODULE_NAME .. ".behavior")
g_BehaviorExtend = behavior.behaviorExtend
g_BehaviorBase = behavior.behaviorBase
g_BehaviorMap = behavior.behaviorMap

-- mvc基础类
local base = import(CURRENT_MODULE_NAME .. ".base")
g_BaseView = base.baseView
g_BaseCtr = base.baseCtr
g_BaseData = base.baseData
