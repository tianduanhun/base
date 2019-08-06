
function cc.Node:pos(x, y)
    if not y and type(x) == "table" then
        y = x.y
        x = x.x
    end
    self:setPosition(x, y)
    return self
end

function cc.Node:align(anchorPoint, x, y)
    self:setAnchorPoint(display.ANCHOR_POINTS[anchorPoint])
    if x then
        self:pos(x, y)
    end
    return self
end

--[[
    @desc: 给节点绑定单点触摸事件
    author:BogeyRuan
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
    author:BogeyRuan
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
    author:BogeyRuan
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
    author:BogeyRuan
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
    author:BogeyRuan
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
    author:BogeyRuan
    time:2019-07-03 14:14:28
    --@size: 
    @return:
]]
function cc.sizeToP(size)
    return cc.p(size.width, size.height)
end

--[[
    @desc: 点转为size
    author:BogeyRuan
    time:2019-07-03 14:14:47
    --@p: 
    @return: [luaIde#cc.Size]
]]
function cc.pToSize(p)
    return cc.size(p.x, p.y)
end

---------------------------------------------------------------------Shader Start
--[[
    @desc: 获取渲染节点，主要是cc.Sprite 和 cc.Label
    author:BogeyRuan
    time:2019-06-26 11:12:16
    --@node:
    --@tb: 
    --@cascadeChildren: 是否级联子节点
    @return:
]]
local function getRealNodes(node, tb, cascadeChildren)
    if not cascadeChildren then
        local nodeType = tolua.type(node)
        if nodeType == "cc.Sprite" then
            table.insert(tb, node)
        elseif nodeType == "ccui.Scale9Sprite" then
            -- getRealNodes(node:getSprite(), tb)
            table.insert(tb, node)
        elseif nodeType == "ccui.Text" then
            getRealNodes(node:getVirtualRenderer(), tb)
        elseif nodeType == "ccui.Button" then
            getRealNodes(node:getVirtualRenderer(), tb)
            getRealNodes(node:getTitleRenderer(), tb)
        elseif nodeType == "cc.Label" then
            if node:getString() ~= "" then
                table.insert(tb, node)
            end
        elseif nodeType == "cc.RenderTexture" then
            getRealNodes(node:getSprite(), tb)
        else
            table.insert(tb, node)
        end
    else
        getRealNodes(node, tb)
        local children = node:getChildren()
        for k,v in pairs(children) do
            getRealNodes(v, tb, cascadeChildren)
        end
    end
end

--[[
    @desc: 高斯模糊[shader实现，掉帧严重]
    author:BogeyRuan
    time:2019-05-15 14:26:45
    --@node: 要变模糊的节点
    --@cascadeChildren: 是否级联子节点
    --@level: 模糊级别，尽量不要超过5
    @return:
]]
function display.makeBlur(node, cascadeChildren, level)
    local nodes = {}
    getRealNodes(node, nodes, cascadeChildren)
    for _, node in pairs(nodes) do
        if tolua.type(node) == "cc.Label" then
            local displayNode = display.captureNode(node, {bigger = 10})
            displayNode:getSprite():align(display.BOTTOM_LEFT, -10, -10)
            display.makeBlur(displayNode)
            node:setDisplayNode(displayNode)
        else
            local size = node:getContentSize()
            if size.width > 0 and size.height > 0 then
                local resolution = cc.p(size.width, size.height)
                level = level or 1
                assert(level > 0, "level must be greater than zero")
                local glProgram = cc.GLProgram:createWithByteArrays(g_FileUtils.getFileContent(PKGPATH .. "shader/Shader_PositionTextureColor_noMVP"), g_FileUtils.getFileContent(PKGPATH .. "shader/GaussianBlur"))
                local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
                glProgramState:setUniformVec2("resolution" , resolution)
                glProgramState:setUniformFloat("level", level)
                node:setGLProgramState(glProgramState)
            end
        end
    end
end

--[[
    @desc: 节点置灰[按钮的置灰只置灰当前显示的状态]
    author:BogeyRuan
    time:2019-05-15 16:19:26
    --@node: 
    --@cascadeChildren: 是否级联子节点
    @return:
]]
function display.makeGray(node, cascadeChildren)
    local nodes = {}
    getRealNodes(node, nodes, cascadeChildren)
    for _, node in pairs(nodes) do
        if tolua.type(node) == "cc.Label" then
            local displayNode = display.captureNode(node)
            display.makeGray(displayNode)
            node:setDisplayNode(displayNode)
        else
            local glProgram = cc.GLProgramCache:getInstance():getGLProgram("Gray")
            if not glProgram then
                glProgram = cc.GLProgram:createWithByteArrays(g_FileUtils.getFileContent(PKGPATH .. "shader/Shader_PositionTextureColor_noMVP"), g_FileUtils.getFileContent(PKGPATH .. "shader/Gray"))
                cc.GLProgramCache:getInstance():addGLProgram(glProgram, "Gray")
            end
            local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
            node:setGLProgramState(glProgramState)
        end
    end
end

--[[
    @desc: 恢复默认glProgramState
    author:BogeyRuan
    time:2019-05-15 15:32:53
    --@node: 
    --@cascadeChildren: 是否级联子节点
    @return:
]]
function display.makeNormal(node, cascadeChildren)
    local nodes = {}
    getRealNodes(node, nodes, cascadeChildren)
    for _, node in pairs(nodes) do
        if tolua.type(node) == "cc.Label" then
            node:setDisplayNode()
        else
            local glProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
            local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
            node:setGLProgramState(glProgramState)
        end
    end
end

--[[
    @desc: 截取指定节点
    author:BogeyRuan
    time:2019-07-03 12:22:00
    --@node:
	--@params: {
        size: 截取的大小
        bigger: 外扩宽度
    }
    @return: [luaIde#cc.RenderTexture]
]]
function display.captureNode(node, params)
    params = checktable(params)
    local bigger = params.bigger or 0
    local node = node or display.getRunningScene()
    -- 因为截取指定区域的函数的限制，得先把父节点和自己移动到左下角
    local parent = node:getParent()
    local parentPos
    if parent then
        parentPos = cc.p(parent:getPosition())
        local basePos = parent:convertToWorldSpace(cc.p(0, 0))
        parent:setPosition(cc.pSub(parentPos, basePos))
    end
    local nodePos = cc.p(node:getPosition())
    local nodeSize = node:getContentSize()
    local nodeBasePos = node:convertToWorldSpace(cc.p(0,0))
    node:setPosition(nodePos.x - nodeBasePos.x + bigger, nodePos.y - nodeBasePos.y + bigger)
    nodeSize = params.size or nodeSize

    local texture = cc.RenderTexture:create(nodeSize.width + 2 * bigger, nodeSize.height + 2 * bigger, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
    texture:beginWithClear(0, 0, 0, 0)
    node:visit()
    texture:endToLua()

    if parent then
        parent:setPosition(parentPos)
    end
    node:setPosition(nodePos)

    texture:getSprite():align(display.BOTTOM_LEFT, 0, 0)
    return texture
end

--[[
    @desc: 截取一张指定节点指定位置的模糊截图
    author:BogeyRuan
    time:2019-05-21 15:56:15
    --@[node]: 指定的节点
    --@[params]: {
        size: 指定的范围，默认节点size
        level: 模糊等级，默认1
        bigger: 外扩范围， 默认10
    }
    @return: [luaIde#cc.RenderTexture]
]]
function display.captureBlurNode(node, params)
    params = checktable(params)
    local bigger = params.bigger or 10
    local texture = display.captureNode(node, {size = params.size, bigger = bigger})
    texture:pos(0, 0)
    local blurSp = texture:getSprite()
    blurSp:align(display.BOTTOM_LEFT, 0, 0)
    display.makeBlur(blurSp, false, params.level)

    local size = blurSp:getContentSize()
    local texture2 = cc.RenderTexture:create(size.width, size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
    texture2:beginWithClear(0, 0, 0, 0)
    blurSp:visit()
    texture2:endToLua()
    texture2:getSprite():align(display.BOTTOM_LEFT, -bigger, -bigger)

    return texture2
end
---------------------------------------------------------------------Shader Ended