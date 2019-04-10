local init = {
    getData = function()
        return require("hallData")
    end,
    _DESTROY = function()
        require("hallData"):destroy()
    end
}

return init