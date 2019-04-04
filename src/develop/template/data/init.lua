local init = {
    getData = function()
        return require("templateData")
    end,
    _DESTROY = function()
        require("templateData"):destroy()
    end
}

return init