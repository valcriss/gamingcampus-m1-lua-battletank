local Component      = require "models.scenes.Component"

---@class DialogBackground
DialogBackground     = {}

DialogBackground.new = function()
    local dialogBackground = Component.new("DialogBackground")

    setmetatable(dialogBackground, DialogBackground)
    DialogBackground.__index = DialogBackground

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    function dialogBackground.draw()
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    return dialogBackground
end

return DialogBackground
