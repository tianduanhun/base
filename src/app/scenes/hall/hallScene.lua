local HallScene = class("HallScene", g_BaseScene)

--初始化到显示 方法执行顺序 onCreate -> buildCtr -> onEnter
function HallScene:onCreate(...)
end

function HallScene:buildCtr()
    return require("hallCtr").new(self)
end

function HallScene:onEnter()
end

function HallScene:onDestroy()
end
--------------------------------------------------

return HallScene
