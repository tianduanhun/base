local init = {
    getData = function()
        return require("templateData"):getInstance()
    end,
    _DESTROY = function()
        require("templateData"):destroy()
    end
}

return init