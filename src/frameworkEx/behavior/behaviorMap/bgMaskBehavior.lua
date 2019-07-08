local BgMaskBehavior = class("BgMaskBehavior", g_BehaviorBase)

BgMaskBehavior.exportFuncs = {
    "addBgMask",
    "removeBgMask",
    "resetBgMask"
}

--[[
    @desc: 
    author:BogeyRuan
    time:2019-07-04 10:15:20
    --@object: 
	--@parent: 要加载背景的节点
	--@params: {
        color: 背景颜色，默认背景为70%黑色背景
        shieldNode: 在这个节点区域内的触摸事件将被屏蔽
        callback: 点击屏蔽节点以外区域的回调
        isSwallTouch: 是否吞没事件,默认true
        isBlur: 是否模糊背景，模糊背景的话color属性将固定为0.8
    }
    @return:
]]
function BgMaskBehavior:addBgMask(object, parent, params)
    assert(parent, "Must have a parent node")
    params = checktable(params)
    local color = params.color or 0.8
    local shieldNode = params.shieldNode
    local callback = params.callback
    local isBlur = params.isBlur
    local isSwallTouch = params.isSwallTouch == nil and true or params.isSwallTouch

    if shieldNode then
        local bgParent = shieldNode
        repeat
            bgParent = bgParent:getParent()
        until(bgParent == parent or bgParent == nil)
        assert(bgParent ~= nil, "The node must be a descendant of the parent node")
    end
    if type(color) == "number" then
        if color <= 1 then
            color = cc.c4b(0, 0, 0, 255 * color)
        else
            color = cc.c4b(0, 0, 0, color)
        end
    end

    local pos = parent:convertToNodeSpace(cc.p(0, 0))
    local layer = object._bgMaskLayer
    if not layer then
        layer = cc.LayerColor:create(color):addTo(parent, -1000):pos(pos)
    end
    local blurLayer = object._bgBlurLayer
    if isBlur then
        blurLayer = display.captureBlurNode():addTo(parent, -1001):pos(pos)
        layer:setColor(cc.c3b(0, 0, 0))
        layer:setOpacity(255 * 0.8)
    end

    layer:onTouch(function (event)
        if event.name == "ended" and event.isClick then
            if shieldNode and callback then
                local size = shieldNode:getContentSize()
                local pos = shieldNode:convertToWorldSpace(cc.p(0, 0))
                if cc.rectContainsPoint(cc.rect(pos.x, pos.y, size.width, size.height), cc.p(event.x, event.y)) then
                    return
                end
                callback()
            end
        end
    end)
    layer:setTouchSwallowEnabled(isSwallTouch)
    object._bgMaskLayer = layer
    object._bgBlurLayer = blurLayer
    object._bgMaskParams = {
        parent = parent,
        color = color,
        shieldNode = shieldNode,
        callback = callback,
        isBlur = isBlur,
        isSwallTouch = isSwallTouch
    }
end

function BgMaskBehavior:removeBgMask(object)
    if object._bgMaskLayer then
        object._bgMaskLayer:removeFromParent()
        object._bgMaskLayer = nil
    end
    if object._bgBlurLayer then
        object._bgBlurLayer:removeFromParent()
        object._bgBlurLayer = nil
    end
    object._bgMaskParams = {}
    object._bgMaskParams = nil
end

function BgMaskBehavior:resetBgMask(object)
    local params = object._bgMaskParams
    if params then
        object:removeBgMask()
        object:addBgMask(params.parent, params)
    end
end

return BgMaskBehavior