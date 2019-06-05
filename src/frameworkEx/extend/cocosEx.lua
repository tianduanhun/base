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
    @desc: size的现加
    author:BogeyRuan
    time:2019-05-28 11:33:40
    --@size: 基础size
	--@width: 增加的宽或者增加的size
	--@height: 增加的高
    @return:
]]
function cc.sizeAdd(size, width, height)
    if type(width) == "table" then
        height = width.height
        width = width.width
    end
    return cc.size(size.width + width, size.height + height)
end

--[[
    @desc: size的现减
    author:BogeyRuan
    time:2019-05-28 11:34:43
    --@size: 基础size
	--@width: 减少的宽或者减少的size
	--@height: 减少的高
    @return:
]]
function cc.sizeSub(size, width, height)
    if type(width) == "table" then
        height = width.height
        width = width.width
    end
    return cc.size(size.width - width, size.height - height)
end

---------------------------------------------------------------------Shader Start
local function getRealNodes(node, tb)
    local nodeType = tolua.type(node)
    if nodeType == "cc.Sprite" or nodeType == "ccui.Scale9Sprite" then
        table.insert(tb, node)
    elseif nodeType == "ccui.Button" then
        getRealNodes(node:getVirtualRenderer(), tb)
        getRealNodes(node:getTitleRenderer(), tb)
    elseif nodeType == "cc.Label" then
        node:updateContent()    --先刷新内部精灵
        getRealNodes(node:getChildren()[1], tb)
    elseif nodeType == "cc.RenderTexture" then
        getRealNodes(node:getSprite(), tb)
    elseif string.find(nodeType, "ccui") then
        getRealNodes(node:getVirtualRenderer(), tb)
    end
end

--[[
    @desc: 高斯模糊[shader实现，掉帧严重]
    author:BogeyRuan
    time:2019-05-15 14:26:45
    --@node: 要变模糊的节点
	--@[radius]: 模糊半径，默认10，半径越大效率越低
	--@[resolution]: 采样粒度，大多数时间不用传
    @return:
]]
function display.makeBlur(node, radius, resolution)
    local nodes = {}
    getRealNodes(node, nodes)
    for _, node in pairs(nodes) do
        if resolution == nil then
            local size = node:getContentSize()
            if size.width == 0 or size.height == 0 then
                return
            end
            resolution = cc.p(size.width, size.height)
        end
        if radius == nil then
            radius = 10
        end
    
        local glProgram = cc.GLProgram:createWithByteArrays(g_FileUtils.getFileContent(PKGPATH .. "shader/Shader_PositionTextureColor"), g_FileUtils.getFileContent(PKGPATH .. "shader/GaussianBlur"))
        local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
        glProgramState:setUniformVec2("resolution" , resolution)
        glProgramState:setUniformFloat("blurRadius", radius)
        node:setGLProgramState(glProgramState)
    end
end

--[[
    @desc: 节点置灰[按钮的置灰只置灰当前显示的状态]
    author:BogeyRuan
    time:2019-05-15 16:19:26
    --@node: 
    @return:
]]
function display.makeGray(node)
    local nodes = {}
    getRealNodes(node, nodes)
    for _, node in pairs(nodes) do
        local glProgram = cc.GLProgramCache:getInstance():getGLProgram("Gray")
        if not glProgram then
            glProgram = cc.GLProgram:createWithByteArrays(g_FileUtils.getFileContent(PKGPATH .. "shader/Shader_PositionTextureColor"), g_FileUtils.getFileContent(PKGPATH .. "shader/Gray"))
            cc.GLProgramCache:getInstance():addGLProgram(glProgram, "Gray")
        end
        local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
        node:setGLProgramState(glProgramState)
    end
end

--[[
    @desc: 恢复默认glProgramState
    author:BogeyRuan
    time:2019-05-15 15:32:53
    --@node: 
    @return:
]]
function display.makeNormal(node)
    local nodes = {}
    getRealNodes(node, nodes)
    for _, node in pairs(nodes) do
        local glProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
        local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
        node:setGLProgramState(glProgramState)
    end
end

--[[
    @desc: 截取一张模糊的当前场景的节点
    author:BogeyRuan
    time:2019-05-21 15:56:15
    @return: 
]]
function display.captureBlurScene()
    local scene = display.getRunningScene()
    local texture = cc.RenderTexture:create(display.width, display.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
    texture:beginWithClear(0, 0, 0, 0)
    scene:visit()
    texture:endToLua()

    texture:pos(0, 0)
    local blurSp = texture:getSprite()
    local size = blurSp:getContentSize()
    blurSp:align(display.CENTER, size.width / 2, size.height / 2)
    display.makeBlur(blurSp)

    local texture2 = cc.RenderTexture:create(size.width, size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, gl.DEPTH24_STENCIL8_OES)
    texture2:beginWithClear(0, 0, 0, 0)
    blurSp:visit()
    texture2:endToLua()

    return texture2
end
---------------------------------------------------------------------Shader Ended