require("createUtils")

local params = {
    modName = "login",
    isUseView = true, --是否使用界面

    isUseData = true --是否使用数据模块
}

local function create()
    local fileName = string.lowerFirst(params.modName)
    local modName = string.upperFirst(params.modName)

    -- 界面
    if params.isUseView then
        -- 目录结构
        local modDir = "../../app/views/" .. string.lower(params.modName) .. "/"
        io.mkdir(modDir)
        io.mkdir(modDir .. "res/")

        -- 基础文件
        local baseConfig = {
            [1] = {fileName .. "Ctr", "view/templateCtr"},
            [2] = {fileName .. "View", "view/templateView"},
            [3] = {"init", "view/init"}
        }
        for i, v in ipairs(baseConfig) do
            local file = modDir .. v[1] .. ".lua"
            if not io.exists(file) then
                local content = io.readfile(v[2] .. ".lua")
                content = string.gsub(content, "Template", modName)
                content = string.gsub(content, "template", fileName)
                io.writefile(file, content)
            else
                print(table.concat({"[Warning][views]:'", file, "' exists"}))
            end
        end
    end
    
    -- 数据模块
    if params.isUseData then
        local modDir = "../../app/data/" .. string.lower(params.modName) .. "/"
        io.mkdir(modDir)

        -- 基础文件
        baseConfig = {
            [1] = {fileName .. "Data", "data/templateData"},
            [2] = {"init", "data/init"}
        }
        for i, v in ipairs(baseConfig) do
            local file = modDir .. v[1] .. ".lua"
            if not io.exists(file) then
                local content = io.readfile(v[2] .. ".lua")
                content = string.gsub(content, "Template", modName)
                content = string.gsub(content, "template", fileName)
                io.writefile(file, content)
            else
                print(table.concat({"[Warning][data]:'", file, "' exists"}))
            end
        end

        -- proto
        local protoDir = modDir .. "proto/"
        io.mkdir(protoDir)

        local file = protoDir .. "pbConfig.lua"
        if not io.exists(file) then
            local content = io.readfile("data/proto/pbConfig.lua")
            content = string.gsub(content, "Template", modName)
            content = string.gsub(content, "template", fileName)
            io.writefile(file, content)
        else
            print(table.concat({"[Warning][data]:'", file, "' exists"}))
        end

        -- config
        local configDir = modDir .. "config/"
        io.mkdir(configDir)

        local file = configDir .. "config.lua"
        if not io.exists(file) then
            local content = io.readfile("data/config/config.lua")
            content = string.gsub(content, "Template", modName)
            content = string.gsub(content, "template", fileName)
            io.writefile(file, content)
        else
            print(table.concat({"[Warning][data]:'", file, "' exists"}))
        end
    end
end

create()
