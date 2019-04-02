local M = {}

local FileUtils = cc.FileUtils:getInstance()
--[[
    @desc: 判断文件夹是否存在
    author:BogeyRuan
    time:2019-02-25 17:23:50
    --@dir: 
    @return:
]]
function M.isDirExist(dir)
    return FileUtils:isDirectoryExist(dir)
end

--[[
    @desc: 创建文件夹
    author:BogeyRuan
    time:2019-02-25 17:23:41
    --@dir: 
    @return:
]]
function M.createDir(dir)
    FileUtils:createDirectory(dir)
end

--[[
    @desc: 保证文件夹存在
    author:BogeyRuan
    time:2019-02-25 17:23:32
    --@dir: 
    @return:
]]
function M.checkDir(dir)
    if not M.isDirExist(dir) then
        M.createDir(dir)
    end
end

--[[
    @desc: 判断文件是否存在
    author:BogeyRuan
    time:2019-02-25 17:23:50
    --@dir: 
    @return:
]]
function M.isFileExist(path)
    return FileUtils:isFileExist(path)
end

--[[
    @desc: 获取文件内容
    author:BogeyRuan
    time:2019-02-26 11:28:34
    --@path: 
    @return:
]]
function M.getFileContent(path)
    if M.isFileExist(path) then
        return FileUtils:getStringFromFile(path)
    end
end

--[[
    @desc: 获取给定路径的全路径
    author:BogeyRuan
    time:2019-02-27 14:58:47
    --@path: 
    @return:
]]
function M.getFullPath(path)
    return FileUtils:fullPathForFilename(path)
end

return M