
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
    @desc: 用指定字符或字符串分割输入字符串，返回包含分割结果的数组
    author:BogeyRuan
    time:2019-03-27 17:42:02
    --@input:
	--@delimiter: 
    @return:
]]
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

--[[
    @desc: 去掉字符串首尾的空白字符，返回结果
    author:BogeyRuan
    time:2019-03-27 17:42:36
    --@input: 
    @return:
]]
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
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
    return string.lower(string.sub(str, 1, 1)) .. string.sub(str, 2, -1)
end

--[[
    @desc: 将数值格式化为包含千分位分隔符的字符串
    author:BogeyRuan
    time:2019-03-27 17:43:38
    --@num: 
    @return:
]]
function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

--[[
    @desc: 计算 UTF8 字符串的长度，每一个中文算一个字符
    author:BogeyRuan
    time:2019-03-27 17:44:10
    --@input: 
    @return:
]]
function string.utf8len(input)
    local left = string.len(input)
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left > 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

--[[
    @desc: 将 URL 中的特殊字符还原，并返回结果
    author:BogeyRuan
    time:2019-03-27 17:45:26
    --@input: 
    @return:
]]
function string.urldecode(input)
    input = string.gsub (input, "+", " ")
    input = string.gsub (input, "%%(%x%x)", function(h) return string.char(checknumber(h,16)) end)
    input = string.gsub (input, "\r\n", "\n")
    return input
end