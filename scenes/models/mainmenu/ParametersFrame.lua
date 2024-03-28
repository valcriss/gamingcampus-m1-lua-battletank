local MenuFrame = require "scenes.models.mainmenu.MenuFrame"

---@class ParametersFrame
ParametersFrame = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
ParametersFrame.new = function(name, title, x, y, width, height, moveSpeed)
    local parametersFrame = MenuFrame.new(name, title, x, y, width, height, moveSpeed, "assets/ui/red_panel.png")

    setmetatable(parametersFrame, ParametersFrame)
    ParametersFrame.__index = ParametersFrame

    function parametersFrame.update(dt)
        parametersFrame.updateAnimation(dt)
    end

    return parametersFrame
end

return ParametersFrame
