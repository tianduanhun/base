require("createUtils")

local mod = {
    SCENE = {path = "scenes/", tag = 1},
    VIEW = {path = "views/", tag = 2}
}

local params = {
    mod = mod.SCENE,
    sceneName = "hall"
}

local function create()
    local fileName = string.lowerFirst(params.sceneName)
    local modName = string.upperFirst(params.sceneName)

    -- 目录结构
    local modDir = "../../app/" .. params.mod.path .. string.lower(params.sceneName) .. "/"
    io.mkdir(modDir)

    -- 基础文件
    local baseConfig = {
        [1] = {fileName .. "Scene", "templateScene"},
        [2] = {fileName .. "Ctr", "templateCtr"},
        [3] = {fileName .. "View", "templateView"},
        [4] = {"init", "init_" .. params.mod.tag}
    }
    for i, v in ipairs(baseConfig) do
        if not (params.mod.tag == 2 and i == 1) then
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
