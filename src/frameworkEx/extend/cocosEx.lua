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

local function getRealNode(node)
    local nodeType = tolua.type(node)
    if nodeType == "ccui.Scale9Sprite" then
        return node
    elseif nodeType == "cc.RenderTexture" then
        return node:getSprite()
    elseif string.find(nodeType, "ccui") then
        return node:getVirtualRenderer()
    end
    return node
end

--[[
    @desc: 高斯模糊
    author:BogeyRuan
    time:2019-05-15 14:26:45
    --@node: 要变模糊的节点
	--@[radius]: 模糊半径，默认25
	--@[resolution]: 采样粒度，大多数时间不用传
    @return:
]]
function display.makeBlur(node, radius, resolution)
    node = getRealNode(node)
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

--[[
    @desc: 节点置灰[按钮的置灰只置灰当前显示的状态]
    author:BogeyRuan
    time:2019-05-15 16:19:26
    --@node: 
    @return:
]]
function display.makeGray(node)
    node = getRealNode(node)
    local glProgram = cc.GLProgramCache:getInstance():getGLProgram("Gray")
    if not glProgram then
        glProgram = cc.GLProgram:createWithByteArrays(g_FileUtils.getFileContent(PKGPATH .. "shader/Shader_PositionTextureColor"), g_FileUtils.getFileContent(PKGPATH .. "shader/Gray"))
        cc.GLProgramCache:getInstance():addGLProgram(glProgram, "Gray")
    end
    local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
    node:setGLProgramState(glProgramState)
end

--[[
    @desc: 恢复默认glProgramState
    author:BogeyRuan
    time:2019-05-15 15:32:53
    --@node: 
    @return:
]]
function display.makeNormal(node)
    node = getRealNode(node)
    local glProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
    local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(glProgram)
    node:setGLProgramState(glProgramState)
end

function display.captureBlurScene()
    local scene = display.getRunningScene()
    local texture = cc.RenderTexture:create(display.width, display.height)
    texture:beginWithClear(0, 0, 0, 0)
    scene:visit()
    texture:endToLua()

    local textureSp = texture:getSprite()
    display.makeBlur(textureSp)
    local texture2 = cc.RenderTexture:create(textureSp:getContentSize().width, textureSp:getContentSize().height)
    texture2:beginWithClear(0, 0, 0, 0)
    textureSp:visit()
    texture2:endToLua()

    local blurSp = cc.Sprite:createWithSpriteFrame(texture2:getSprite():getSpriteFrame())
    blurSp:setRotation(180)

    return blurSp
end