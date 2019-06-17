
--[[
    @desc: 判断字段是否为空
    author:{author}
    time:2019-02-12 14:55:00
    --@str: 要判断的字段
    @return: 布尔值
]]
function string.isEmpty(str)
    if type(str) ~= "string" or str == "" then
        return true
    end
    return false
end

--[[
    @desc: 将字符串的第一个字符转为大写，返回结果
    author:BogeyRuan
    time:2019-03-27 17:43:03
    --@input: 
    @return:
]]
function string.upperFirst(input)
    return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end

--[[
    @desc: 将字符串的第一个字符转为小写，返回结果
    author:BogeyRuan
    time:2019-04-11 10:35:48
    --@input: 
    @return:
]]
function string.lowerFirst(input)
    return string.lower(string.sub(input, 1, 1)) .. string.sub(input, 2, -1)
end

--[[
    @desc: 根据传入的成对的字符串拆分文字
    author:BogeyRuan
    time:2019-06-17 11:04:07
    --@str: 要拆分的文字
	--@config: 成对的字符串集合，如{"#*", "()"}
    @return: 返回拆出来的文字，并附加文字被包含的索引,普通文字索引为配置数加1
    @example: string.splitByConfig("ab#cde*fg", {"#*"})
    @result: {{text = "ab", index = 2}, {text = "cde", index = 1}, {text = "fg", index = 2}}
]]
function string.splitByConfig(str, config)
    local configNum = #config
    local strTemp = {}
    local indexs = {}   --所有特殊字符下标合集
    local index = 1
    while true do
        local flag = true
        local realHead, realEnd, indexInConfig
        for i,v in ipairs(config) do
            local tempHead, tempEnd = string.find(str, string.format("%%b%s", v), index)
            if tempHead then
                flag = false
                if (not realHead) or realHead > tempHead then
                    realHead, realEnd, indexInConfig = tempHead, tempEnd, i
                end
            end
        end
        if flag then
            break
        else
            index = realEnd + 1
            table.insert(indexs, {i = realHead, j = realEnd, index = indexInConfig})
        end
    end

    if table.isEmpty(indexs) then
        return {{text = str, index = configNum + 1}}
    end

    for i,v in ipairs(indexs) do
        local info = indexs[i - 1]
        local lastIndex
        if info then
            lastIndex = info.j + 1
        else
            lastIndex = 1
        end

        local normalStr = string.sub(str, lastIndex, v.i - 1)
        if normalStr and not string.isEmpty(normalStr) then
            table.insert(strTemp, {text = normalStr, index = configNum + 1})
        end

        local specialStr = string.sub(str, v.i, v.j)
        specialStr = string.sub(specialStr, 2, -2)
        if specialStr and not string.isEmpty(specialStr) then
            table.insert(strTemp, {text = specialStr, index = v.index})
        end
    end

    local lastIndex = indexs[#indexs].j + 1
    local normalStr = string.sub(str, lastIndex)
    if normalStr and not string.isEmpty(normalStr) then
        table.insert(strTemp, {text = normalStr, index = configNum + 1})
    end
    
    return strTemp
end