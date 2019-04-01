local BgMaskBehavior = class("BgMaskBehavior", g_BehaviorBase)

BgMaskBehavior.exportFuncs = {
    "addBgMask",
    "removeBgMask"
}

function BgMaskBehavior:addBgMask(object, parent, color, bgNode, callback, isSwallTouch)
    assert(parent, "")
    assert(color, "")
    if bgNode then
        assert(parent == bgNode:getParent())
    end
    if type(color) == "number" then
        if color <= 1 then
            color = cc.c4b(0, 0, 0, 255 * color)
        else
            color = cc.c4b(0, 0, 0, color)
        end
    end
    isSwallTouch = isSwallTouch == nil and true or isSwallTouch

    local layer = object._bgMaskLayer
    if not layer then
        local pos = parent:convertToNodeSpace(cc.p(0, 0))
        layer = cc.LayerColor:create(color):addTo(parent, -1000):pos(pos)
    end
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "ended" then
            if bgNode and callback then
                local size = bgNode:getContentSize()
                local pos = bgNode:convertToWorldSpace(cc.p(0, 0))
                if cc.rectContainsPoint(cc.rect(pos.x, pos.y, size.width, size.height), cc.p(event.x, event.y)) then
                    return
                end
                callback()
            end
        end
    end)
    layer:setTouchSwallowEnabled(isSwallTouch)
    layer:setTouchEnabled(true)
    object._bgMaskLayer = layer
end

function BgMaskBehavior:removeBgMask(object)
    if object._bgMaskLayer then
        object._bgMaskLayer:removeFromParent()
        object._bgMaskLayer = nil
    end
end

return BgMaskBehavior