local BgMaskBehavior = class("BgMaskBehavior", g_BaseBehavior)

BgMaskBehavior.exportFuncs = {
    "addBgMask",
    "removeBgMask",
    "resetBgMask"
}

--[[
    @desc: 
    author:Bogey
    time:2019-07-04 10:15:20
    --@object: 
	--@parent: 要加载背景的节点
	--@params: {
        color: 背景颜色，默认背景为50%黑色背景
        shieldNode: 在这个节点区域内的触摸事件将被屏蔽
        callback: 点击屏蔽节点以外区域的回调
        isSwallTouch: 是否吞没事件,默认true
    }
    @return:
]]
function BgMaskBehavior:addBgMask(object, parent, params)
    assert(parent, "Must have a parent node")
    params = checktable(params)
    local color = params.color or 0.5
    local shieldNode = params.shieldNode
    local callback = params.callback
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
    local layer = self._bgMaskLayer
    if not layer then
        layer = cc.LayerColor:create(color):addTo(parent, -1000):align(display.CENTER, cc.pAdd(cc.p(display.cx, display.cy),pos)):size(cc.sizeMul(display.size,2))
    end
    
    layer:onTouch(function (event, isClick)
        if isClick then
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
    self._bgMaskLayer = layer
    self._bgMaskParams = {
        parent = parent,
        color = color,
        shieldNode = shieldNode,
        callback = callback,
        isSwallTouch = isSwallTouch
    }
end

function BgMaskBehavior:removeBgMask(object)
    if self._bgMaskLayer then
        self._bgMaskLayer:removeFromParent()
        self._bgMaskLayer = nil
    end
    self._bgMaskParams = {}
    self._bgMaskParams = nil
end

function BgMaskBehavior:resetBgMask(object, params)
    params = checktable(params)
    table.fill(params, self._bgMaskParams)
    if params.parent then
        self:removeBgMask(object)
        self:addBgMask(object, params.parent, params)
    end
end

return BgMaskBehavior