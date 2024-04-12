local LeftMenuFrame = require "models.ui.LeftMenuFrame"
local BitmapText    = require "models.texts.BitmapText"

---@class PauseMenuFrame
PauseMenuFrame      = {}

PauseMenuFrame.new  = function(name, title, x, y, width, height, moveSpeed, content)
    local pauseMenuFrame = LeftMenuFrame.new(name, title, x, y, width, height, moveSpeed, "assets/ui/blue_panel.png", { content = content })

    setmetatable(pauseMenuFrame, PauseMenuFrame)
    PauseMenuFrame.__index = PauseMenuFrame

    local informationText  = BitmapText.new(pauseMenuFrame.name .. "_informationText", "assets/ui/ui-18.fnt", "Etes-vous sur de vouloir quitter ?", "center", "center", pauseMenuFrame.bounds.x + pauseMenuFrame.bounds.width / 2, pauseMenuFrame.bounds.y + 20)
    pauseMenuFrame.addComponent(informationText)

    function pauseMenuFrame.update(dt)
        pauseMenuFrame.updateAnimation(dt)
        informationText.setPosition(pauseMenuFrame.bounds.x + pauseMenuFrame.data.offsetX + (pauseMenuFrame.bounds.width / 2), pauseMenuFrame.bounds.y + 30)
    end

    function pauseMenuFrame.setContent(value)
        pauseMenuFrame.data.content = value
        informationText.setContent(pauseMenuFrame.data.content)
    end

    return pauseMenuFrame
end

return PauseMenuFrame
