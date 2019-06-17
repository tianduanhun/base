local CURRENT_MODULE_NAME = ...
CURRENT_MODULE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6)

_require = clone(require)
-- 记录加载的模块
local importModules = {}

local FileUtils = cc.FileUtils:getInstance()
FileUtils:addSearchPath("src/")

local function loadLuaScript(path)
    path = string.gsub(path, "%.", "/")
    local fullPath = FileUtils:fullPathForFilename(path .. ".lua")
    if FileUtils:isFileExist(fullPath) then
        local data = FileUtils:getDataFromFile(fullPath)
        return loadstring(data, fullPath)
    end
end

function import(path)
    assert(path and path ~= "", "The path is empty")
    path = string.gsub(path, "%.", "/")
    local result = importModules[path]
    if not result then
        local env = {}

        env.PKGPATH = path .. "/"
        env.PKGRESPATH = path .. "/res/"

        local function require(path)
            path = string.gsub(path, "%.", "/")
            path = env.PKGPATH .. path
            local result = importModules[path]
            if not result then
                local loadFunc = loadLuaScript(path)
                if type(loadFunc) ~= "function" then
                    error("Loading file error : " .. path)
                end
                setfenv(loadFunc, env)
                result = loadFunc()
                importModules[path] = result
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
        importModules[path] = result
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
            table.insert(temp, key)
        end
    end
    
    table.sort(temp, function(a, b)
        return string.len(a) < string.len(b)
    end)

    for i, v in ipairs(temp) do
        if importModules[v]._DESTROY and type(importModules[v]._DESTROY) == "function" then
            importModules[v]._DESTROY()
        end
        importModules[v] = nil
    end
end

-- 加载自定义框架,先加载utils
local dirs = {"utils", "lib", "event", "database", "socket", "extend", "behavior", "base", "native"}
for i, v in ipairs(dirs) do
    local module = import(CURRENT_MODULE_NAME .. "." .. v)
    for k, v in pairs(module) do
        _G["g_" .. string.upperFirst(k)] = v
    end
end
