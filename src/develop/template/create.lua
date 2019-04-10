require("createUtils")

local params = {
    modName = "hall",
    isUseData = true
}

local function create()
    local fileName = string.lowerFirst(params.modName)
    local modName = string.upperFirst(params.modName)

    -- 目录结构
    local modDir = "../../app/views/" .. string.lower(params.modName) .. "/"
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
            io.writefile(file, content)
        end
    end

    -- 数据模块
    if params.isUseData then
        modDir = "../../app/data/" .. string.lower(params.modName) .. "/"
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
            end
        end
    end
end

create()
