local g_FileUtils = {}

local FileUtils = cc.FileUtils:getInstance()
--[[
    @desc: 判断文件夹是否存在
    author:BogeyRuan
    time:2019-02-25 17:23:50
    --@dir: 
    @return:
]]
function g_FileUtils.isDirExist(dir)
    return FileUtils:isDirectoryExist(dir)
end

--[[
    @desc: 创建文件夹
    author:BogeyRuan
    time:2019-02-25 17:23:41
    --@dir: 
    @return:
]]
function g_FileUtils.createDir(dir)
    FileUtils:createDirectory(dir)
end

--[[
    @desc: 保证文件夹存在
    author:BogeyRuan
    time:2019-02-25 17:23:32
    --@dir: 
    @return:
]]
function g_FileUtils.checkDir(dir)
    if not g_FileUtils.isDirExist(dir) then
        g_FileUtils.createDir(dir)
    end
end

--[[
    @desc: 判断文件是否存在
    author:BogeyRuan
    time:2019-02-25 17:23:50
    --@dir: 
    @return:
]]
function g_FileUtils.isFileExist(path)
    return FileUtils:isFileExist(path)
end

--[[
    @desc: 获取文件内容
    author:BogeyRuan
    time:2019-02-26 11:28:34
    --@path: 
    @return:
]]
function g_FileUtils.getFileContent(path)
    if g_FileUtils.isFileExist(path) then
        return FileUtils:getDataFromFile(path)
    end
end

--[[
    @desc: 获取给定路径的全路径
    author:BogeyRuan
    time:2019-02-27 14:58:47
    --@path: 
    @return:
]]
function g_FileUtils.getFullPath(path)
    return FileUtils:fullPathForFilename(path)
end

return g_FileUtils