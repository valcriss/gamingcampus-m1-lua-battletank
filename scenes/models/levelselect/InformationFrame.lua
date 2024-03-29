local LeftMenuFrame = require "scenes.models.mainmenu.LeftMenuFrame"
local BitmapText = require "models.texts.BitmapText"

---@class InformationFrame
InformationFrame = {}

InformationFrame.new = function(name, title, x, y, width, height, moveSpeed, content)
    local informationFrame = LeftMenuFrame.new(name, title, x, y, width, height, moveSpeed, "assets/ui/blue_panel.png", {content = content})

    setmetatable(informationFrame, InformationFrame)
    InformationFrame.__index = InformationFrame

    local informationText = BitmapText.new(informationFrame.name .. "_informationText", "assets/ui/ui-18.fnt", "Etes-vous sur de vouloir quitter ?", "center", "center", informationFrame.bounds.x + informationFrame.bounds.width / 2, informationFrame.bounds.y + 20)
    informationFrame.addComponent(informationText)

    function informationFrame.update(dt)
        informationFrame.updateAnimation(dt)
        informationText.setPosition(informationFrame.bounds.x + informationFrame.data.offsetX + (informationFrame.bounds.width / 2), informationFrame.bounds.y + 30)
    end

    function informationFrame.setContent(value)
        informationFrame.data.content = value
        informationText.setContent(informationFrame.data.content)
    end

    return informationFrame
end

return InformationFrame
