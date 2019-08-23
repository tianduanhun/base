--[[
    @desc: 四舍五入
    author:Bogey
    time:2019-08-12 15:57:48
    --@value: 
    @return:
]]
function math.round(value)
    value = checknumber(value)
    return math.floor(value + 0.5)
end