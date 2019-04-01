local BaseData = class("BaseData")

function BaseData:getInstance()
    if self.instance == nil then
        self.instance = self.new()
    end
    return self.instance
end
-------------------------------------------
function BaseData:ctor()
    
end

return BaseData