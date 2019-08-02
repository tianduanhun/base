local init = {
    getData = function()
        return require("loginInterface"):getInstance()
    end,
    getConfig = function()
        return require("config.config")
    end,
    _DESTROY = function()
        require("loginInterface"):destroy()
    end
}

return init