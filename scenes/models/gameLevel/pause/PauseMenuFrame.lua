local LeftMenuFrame = require "models.ui.LeftMenuFrame"
local Button        = require "models.ui.Button"
local BitmapText    = require "models.texts.BitmapText"
local CheckBox      = require "models.ui.CheckBox"

---@class PauseMenuFrame
PauseMenuFrame      = {}

PauseMenuFrame.new  = function(onResume, onBack, onPauseChanged)
    local pauseMenuFrame = LeftMenuFrame.new("PauseMenuFrame", "Jeu en pause", 20, 300, 220, 180, 3000, "assets/ui/yellow_panel.png", { content = "" }, true)

    setmetatable(pauseMenuFrame, PauseMenuFrame)
    PauseMenuFrame.__index = PauseMenuFrame
    local debugActive      = false
    local resumeButton     = Button.new(pauseMenuFrame.name .. "_resumeButton", "assets/ui/green_button00.png", "assets/ui/green_button04.png", "assets/ui/green_button03.png", 0, 0, "Reprendre", function() pauseMenuFrame.resume() end)
    local backButton       = Button.new(pauseMenuFrame.name .. "_backButton", "assets/ui/red_button11.png", "assets/ui/red_button01.png", "assets/ui/red_button02.png", 0, 0, "Retour", function() pauseMenuFrame.back() end)
    local debugLabel       = BitmapText.new(pauseMenuFrame.name .. "_debugLabel", "assets/fonts/roboto-bold-black.fnt", "Debug", "left")
    local debugCheckbox    = CheckBox.new(pauseMenuFrame.name .. "_debugCheckbox", "assets/ui/checkbox_unchecked.png", "assets/ui/checkbox_checked.png", 0, 0, debugActive, function(newValue) pauseMenuFrame.debugChanged(newValue) end)

    pauseMenuFrame.addComponent(resumeButton)
    pauseMenuFrame.addComponent(backButton)
    pauseMenuFrame.addComponent(debugLabel)
    pauseMenuFrame.addComponent(debugCheckbox)

    function pauseMenuFrame.update(dt)
        pauseMenuFrame.updateAnimation(dt)
        resumeButton.setPosition(pauseMenuFrame.bounds.x + pauseMenuFrame.getOffsetX() + 20, pauseMenuFrame.bounds.y + 20)
        backButton.setPosition(pauseMenuFrame.bounds.x + pauseMenuFrame.getOffsetX() + 20, pauseMenuFrame.bounds.y + 80)
        debugLabel.setPosition(pauseMenuFrame.bounds.x + pauseMenuFrame.getOffsetX() + 25, pauseMenuFrame.bounds.y + pauseMenuFrame.bounds.height - 30)
        debugCheckbox.setPosition(pauseMenuFrame.bounds.x + pauseMenuFrame.getOffsetX() + 170, pauseMenuFrame.bounds.y + pauseMenuFrame.bounds.height - 40)
    end

    function pauseMenuFrame.resume()
        onResume()
    end

    function pauseMenuFrame.back()
        onBack()
    end

    function pauseMenuFrame.debugChanged(newValue)
        debugActive = newValue
        onPauseChanged(newValue)
    end

    return pauseMenuFrame
end

return PauseMenuFrame
