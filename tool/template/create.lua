require("createUtils")

local params = {
    modName = "main",
    isUseView = true, --是否使用界面

    isUseData = true --是否使用数据模块
}

local function dealCtrImport(content, bool)
    local num
    while true do
        local start, index, str = string.find(content, "%-%-%[%[(.-)]]")
        if not start then
            break
        end
        if bool then
            content = string.gsub(content, "%-%-%[%[.-]]", str, 1)
        else
            content = string.gsub(content, "%-%-%[%[.-]]", "", 1)
        end
    end
    return content
end

local function create()
    local fileName = string.lowerFirst(params.modName)
    local modName = string.upperFirst(params.modName)

    -- 界面
    if params.isUseView then
        -- 目录结构
        local modDir = "../../src/app/views/" .. string.lower(params.modName) .. "/"
        io.mkdir(modDir)

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
                if i == 1 then
                    content = dealCtrImport(content, params.isUseData)
                end
                io.writefile(file, content)
            else
                print(table.concat({"[Warning][views]:'", file, "' exists"}))
            end
        end
    end
    
    -- 数据模块
    if params.isUseData then
        local modDir = "../../src/app/data/" .. string.lower(params.modName) .. "/"
        io.mkdir(modDir)

        -- 基础文件
        local baseConfig = {
            [1] = {fileName .. "Interface", "data/templateInterface"},
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

        baseConfig = {
            [1] = {"pbConfig.lua", "data/proto/pbConfig.lua"},
            [2] = {fileName .. ".proto", "data/proto/template.proto"}
        }
        for i, v in ipairs(baseConfig) do
            local file = protoDir .. v[1]
            if not io.exists(file) then
                local content = io.readfile(v[2])
                content = string.gsub(content, "Template", modName)
                content = string.gsub(content, "template", fileName)
                io.writefile(file, content)
            else
                print(table.concat({"[Warning][data]:'", file, "' exists"}))
            end
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

        -- 数据
        local dataDir = modDir .. "data/"
        io.mkdir(dataDir)

        local file = dataDir .. fileName .. "Data.lua"
        if not io.exists(file) then
            local content = io.readfile("data/data/templateData.lua")
            content = string.gsub(content, "Template", modName)
            content = string.gsub(content, "template", fileName)
            io.writefile(file, content)
        else
            print(table.concat({"[Warning][data]:'", file, "' exists"}))
        end
    end
end

create()
