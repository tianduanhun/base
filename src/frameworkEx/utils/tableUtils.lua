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
    @desc: 获取表里指定字段的所有值
    author:BogeyRuan
    time:2019-06-17 15:33:28
    --@hashtable:
	--@key: 
    @return:
]]
function table.valuesOfKey(hashtable, key)
    local values = {}
    for k,v in pairs(hashtable) do
        if v[key] then
            values[k] = v[key]
        end
    end
    return values
end

--[[
    @desc: 顺序遍历不连续hash表
    author:BogeyRuan
    time:2019-06-17 15:37:25
    --@tb: 
    @return: 迭代器
]]
function table.pairsByKey(tb)
    local temp = {}
    for key in pairs(tb) do
        temp[#temp + 1] = key
    end
    table.sort(temp)
    local i = 0
    return function ( )
        i = i + 1
        return temp[i], tb[temp[i]]
    end
end