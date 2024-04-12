local LeftMenuFrame = require "models.ui.LeftMenuFrame"
local Button        = require "models.ui.Button"

---@class PauseMenuFrame
PauseMenuFrame      = {}

PauseMenuFrame.new  = function(onResume, onBack)
    local pauseMenuFrame = LeftMenuFrame.new("PauseMenuFrame", "Jeu en pause", 20, 300, 220, 140, 3000, "assets/ui/yellow_panel.png", { content = content }, true)

    setmetatable(pauseMenuFrame, PauseMenuFrame)
    PauseMenuFrame.__index = PauseMenuFrame

    local resumeButton     = Button.new(pauseMenuFrame.name .. "_resumeButton", "assets/ui/green_button00.png", "assets/ui/green_button04.png", "assets/ui/green_button03.png", 0, 0, "Reprendre", function() pauseMenuFrame.resume() end)
    local backButton       = Button.new(pauseMenuFrame.name .. "_backButton", "assets/ui/red_button11.png", "assets/ui/red_button01.png", "assets/ui/red_button02.png", 0, 0, "Retour", function() pauseMenuFrame.back() end)

    pauseMenuFrame.addComponent(resumeButton)
    pauseMenuFrame.addComponent(backButton)

    function pauseMenuFrame.update(dt)
        pauseMenuFrame.updateAnimation(dt)
        resumeButton.setPosition(pauseMenuFrame.bounds.x + pauseMenuFrame.data.offsetX + 20, pauseMenuFrame.bounds.y + 20)
        backButton.setPosition(pauseMenuFrame.bounds.x + pauseMenuFrame.data.offsetX + 20, pauseMenuFrame.bounds.y + 80)
    end

    function pauseMenuFrame.resume()
        onResume()
    end

    function pauseMenuFrame.back()
        onBack()
    end

    return pauseMenuFrame
end

return PauseMenuFrame
