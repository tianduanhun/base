function cc.Node:align(anchorPoint, x, y)
    self:setAnchorPoint(display.ANCHOR_POINTS[anchorPoint])
    if x then self:setPosition(x, y) end
    return self
end

--[[
    @desc: 给节点绑定单点触摸事件
    author:Bogey
    time:2019-06-21 16:30:42
    --@func: 回调方法
    @return:
]]
function cc.Node:onTouch(func)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            local result = func(event)
            if type(result) ~= "boolean" then
                result = true
            end
            return result
        elseif event.name == "ended" then
            local isClick = false
            if math.abs(event.x - event.startX) <= display.width / 100 and math.abs(event.y - event.startY) <= display.width / 100 then
                isClick = true
            end
            func(event, isClick)
        else
            func(event)
        end
    end)
    self:setTouchEnabled(true)
end

--[[
    @desc: size的相加
    author:Bogey
    time:2019-05-28 11:33:40
    --@size: 基础size
	--@width: 增加的宽或者增加的size
	--@height: 增加的高
    @return: [luaIde#cc.Size]
]]
function cc.sizeAdd(size, width, height)
    if type(width) == "table" then
        height = width.height
        width = width.width
    end
    return cc.size(size.width + width, size.height + height)
end

--[[
    @desc: size的相减
    author:Bogey
    time:2019-05-28 11:34:43
    --@size: 基础size
	--@width: 减少的宽或者减少的size
	--@height: 减少的高
    @return: [luaIde#cc.Size]
]]
function cc.sizeSub(size, width, height)
    if type(width) == "table" then
        height = width.height
        width = width.width
    end
    return cc.size(size.width - width, size.height - height)
end

--[[
    @desc: size的缩放
    author:Bogey
    time:2019-06-11 17:32:00
    --@size:
	--@xFactor: x轴缩放或整体缩放
	--@[yFactor]: y轴缩放
    @return: [luaIde#cc.Size]
]]
function cc.sizeMul(size, xFactor, yFactor)
    return {width = size.width * xFactor, height = size.height * (yFactor or xFactor)}  
end

--[[
    @desc: 
    author:Bogey
    time:2019-06-11 15:09:12
    --@_x: x或者pos
	--@_y: y或者size
	--@[_width]: width或者size
	--@[_height]: height
    @return: [luaIde#cc.Rect]
]]
function cc.rect(_x, _y, _width, _height)
    if _height then
        return {x = _x, y = _y, width = _width, height = _height}
    elseif type(_width) == "table" then
        return {x = _x, y = _y, width = _width.width, height = _width.height}
    elseif type(_y) == "table" then
        return {x = _x.x, y = _x.y, width = _y.width, height = _y.height}
    end
end

--[[
    @desc: size转为点
    author:Bogey
    time:2019-07-03 14:14:28
    --@size: 
    @return:
]]
function cc.sizeToP(size)
    return cc.p(size.width, size.height)
end

--[[
    @desc: 点转为size
    author:Bogey
    time:2019-07-03 14:14:47
    --@p: 
    @return: [luaIde#cc.Size]
]]
function cc.pToSize(p)
    return cc.size(p.x, p.y)
end
