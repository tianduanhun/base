--[[
    @desc: 判断表是否为空
    author:{author}
    time:2019-02-12 14:59:21
    --@tb: 
    @return:
]]
function table.isEmpty(tb)
    if type(tb) == "table" then
        return next(tb) == nil
    end
    return true
end
