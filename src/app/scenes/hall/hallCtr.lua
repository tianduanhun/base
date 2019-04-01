local HallCtr = class("HallCtr", g_BaseCtr)

--初始化到显示 方法执行顺序 onCreate -> buildUI -> onEnter
--返回需要注册监听表{key = funcName}
HallCtr.registerEvents = {}
HallCtr.exportFuncs = {}

function HallCtr:onCreate(...)
end

function HallCtr:buildUI()
    return require("hallView").new(self)
end

function HallCtr:onEnter()
end

function HallCtr:onDestroy()
end
--------------------------------------------------

return HallCtr
