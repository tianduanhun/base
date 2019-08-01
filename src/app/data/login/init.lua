local init = {
    getData = function()
        return require("loginData"):getInstance()
    end,
    getConfig = function()
        return require("config.config")
    end,
    _DESTROY = function()
        require("loginData"):destroy()
    end
}

return init