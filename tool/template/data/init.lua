local init = {
    getData = function()
        return require("templateInterface"):getInstance()
    end,
    getConfig = function()
        return require("config.config")
    end,
    _DESTROY = function()
        require("templateInterface"):destroy()
    end
}

return init