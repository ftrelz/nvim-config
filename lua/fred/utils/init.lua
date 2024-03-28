---@class fred.utils
---@field telescope fred.utils.telescope
local M = {}

setmetatable(M, {
    __index = function(t, k)
        t[k] = require("fred.utils." .. k)
        return t[k]
    end
})

return M
