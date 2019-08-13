--[[
    @desc: 校验为数字
    author:BogeyRuan
    time:2019-08-12 15:59:29
    --@value:
	--@base: 
    @return:
]]
function checknumber(value, base)
    return tonumber(value, base) or 0
end

--[[
    @desc: 校验为整数
    author:BogeyRuan
    time:2019-08-12 15:59:44
    --@value: 
    @return:
]]
function checkint(value)
    return math.round(checknumber(value))
end

--[[
    @desc: 校验为布尔值
    author:BogeyRuan
    time:2019-08-12 15:59:56
    --@value: 
    @return:
]]
function checkbool(value)
    return (value ~= nil and value ~= false)
end

--[[
    @desc: 校验为表
    author:BogeyRuan
    time:2019-08-12 16:00:17
    --@value: 
    @return:
]]
function checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end