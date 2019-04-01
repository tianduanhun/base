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


--[[
    @desc: 获取不连续表的元素总数
    author:BogeyRuan
    time:2019-03-27 17:39:49
    --@tb: 
    @return:
]]
function table.nums(tb)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end
