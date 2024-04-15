local LeftMenuFrame  = require "models.ui.LeftMenuFrame"
local BitmapText     = require "models.texts.BitmapText"

---@class InformationFrame
InformationFrame     = {}

InformationFrame.new = function(name, title, x, y, width, height, moveSpeed, content)
    local informationFrame = LeftMenuFrame.new(name, title, x, y, width, height, moveSpeed, "assets/ui/blue_panel.png")

    setmetatable(informationFrame, InformationFrame)
    InformationFrame.__index = InformationFrame

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local informationText    = BitmapText.new(informationFrame.name .. "_informationText", "assets/ui/ui-18.fnt", content, "center", "center", informationFrame.bounds.x + informationFrame.bounds.width / 2, informationFrame.bounds.y + 20)
    informationFrame.addComponent(informationText)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    ---@param dt number
    function informationFrame.update(dt)
        informationFrame.updateAnimation(dt)
        informationText.setPosition(informationFrame.bounds.x + informationFrame.getOffsetX() + (informationFrame.bounds.width / 2), informationFrame.bounds.y + 30)
    end

    ---@public
    ---@param value string
    function informationFrame.setContent(value)
        informationText.setContent(value)
    end

    return informationFrame
end

return InformationFrame
