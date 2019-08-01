local init = {
    getData = function()
        return require("templateData"):getInstance()
    end,
    getConfig = function()
        return require("config.config")
    end,
    _DESTROY = function()
        require("templateData"):destroy()
    end
}

return init