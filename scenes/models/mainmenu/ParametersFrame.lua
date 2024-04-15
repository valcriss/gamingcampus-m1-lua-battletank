local MenuFrame     = require "models.ui.MenuFrame"
local BitmapText    = require "models.texts.BitmapText"
local CheckBox      = require "models.ui.CheckBox"
local Slider        = require "models.ui.Slider"
local Button        = require "models.ui.Button"

---@class ParametersFrame
ParametersFrame     = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
ParametersFrame.new = function(name, title, x, y, width, height, moveSpeed, action)
    local parametersFrame = MenuFrame.new(name, title, x, y, width, height, moveSpeed, "assets/ui/red_panel.png", true)

    setmetatable(parametersFrame, ParametersFrame)
    ParametersFrame.__index  = ParametersFrame

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------

    local fullScreenLabel    = BitmapText.new(parametersFrame.name .. "_fullScreenLabel", "assets/ui/roboto-bold-black.fnt", "Plein Ecran", "left")
    local vSyncLabel         = BitmapText.new(parametersFrame.name .. "_vSyncLabel", "assets/ui/roboto-bold-black.fnt", "Vsync", "left")
    local musicLabel         = BitmapText.new(parametersFrame.name .. "_musicLabel", "assets/ui/roboto-bold-black.fnt", "Volume Musique", "left")
    local soundLabel         = BitmapText.new(parametersFrame.name .. "_soundLabel", "assets/ui/roboto-bold-black.fnt", "Volume Effets", "left")
    local difficultyLabel    = BitmapText.new(parametersFrame.name .. "_difficultyLabel", "assets/ui/roboto-bold-black.fnt", "Difficulté", "left")
    local fullScreenCheckbox = CheckBox.new(parametersFrame.name .. "_fullScreenCheckbox", "assets/ui/checkbox_unchecked.png", "assets/ui/checkbox_checked.png", 0, 0, configuration:isFullScreen())
    local vsyncCheckbox      = CheckBox.new(parametersFrame.name .. "_vsyncCheckbox", "assets/ui/checkbox_unchecked.png", "assets/ui/checkbox_checked.png", 0, 0, configuration:getVsync())
    local musicSlider        = Slider.new(parametersFrame.name .. "_musicSlider", 0, 0, configuration:getMusicVolume())
    local soundSlider        = Slider.new(parametersFrame.name .. "_soundSlider", 0, 0, configuration:getSoundVolume())
    local difficultySlider   = Slider.new(parametersFrame.name .. "_difficultySlider", 0, 0, configuration:getDifficulty(), 0.5, { { min = 0, max = 0.3, text = "Facile" }, { min = 0.3, max = 0.7, text = "Moyen" }, { min = 0.7, max = 1, text = "Difficile" } })
    local confirmButton      = Button.new("confirmButton", "assets/ui/green_button00.png", "assets/ui/green_button04.png", "assets/ui/green_button03.png", parametersFrame.bounds.x + 40, parametersFrame.bounds.y + parametersFrame.bounds.height - 60, "Sauvegarder", function() parametersFrame.saveConfiguration() end)
    local cancelButton       = Button.new("confirmButton", "assets/ui/red_button11.png", "assets/ui/red_button01.png", "assets/ui/red_button02.png", parametersFrame.bounds.x + parametersFrame.bounds.width - 180, parametersFrame.bounds.y + parametersFrame.bounds.height - 60, "Annuler", function() action() end)

    parametersFrame.addComponent(fullScreenCheckbox)
    parametersFrame.addComponent(vsyncCheckbox)
    parametersFrame.addComponent(fullScreenLabel)
    parametersFrame.addComponent(vSyncLabel)
    parametersFrame.addComponent(musicLabel)
    parametersFrame.addComponent(musicSlider)
    parametersFrame.addComponent(soundLabel)
    parametersFrame.addComponent(soundSlider)
    parametersFrame.addComponent(difficultyLabel)
    parametersFrame.addComponent(difficultySlider)
    parametersFrame.addComponent(confirmButton)
    parametersFrame.addComponent(cancelButton)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    ---@param dt number
    function parametersFrame.update(dt)
        parametersFrame.updateAnimation(dt)
        local paddingY      = 20
        local paddingX      = 150
        local textOffset    = 7
        local fullScreenTop = paddingY
        local vSyncTop      = fullScreenTop + fullScreenLabel.getHeight() + paddingY
        local musicTop      = paddingY + vSyncTop + vSyncLabel.getHeight() + paddingY
        local soundTop      = paddingY + musicTop + vSyncLabel.getHeight() + paddingY
        local difficultyTop = paddingY + soundTop + vSyncLabel.getHeight() + paddingY
        fullScreenLabel.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + 20, parametersFrame.bounds.y + textOffset + fullScreenTop)
        fullScreenCheckbox.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + paddingX, parametersFrame.bounds.y + fullScreenTop)
        vSyncLabel.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + 20, parametersFrame.bounds.y + textOffset + vSyncTop + paddingY)
        vsyncCheckbox.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + paddingX, parametersFrame.bounds.y + vSyncTop + paddingY)
        musicLabel.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + 20, parametersFrame.bounds.y + textOffset + musicTop + paddingY)
        musicSlider.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + paddingX, parametersFrame.bounds.y + musicTop + paddingY)
        soundLabel.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + 20, parametersFrame.bounds.y + textOffset + soundTop + paddingY)
        soundSlider.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + paddingX, parametersFrame.bounds.y + soundTop + paddingY)
        difficultyLabel.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + 20, parametersFrame.bounds.y + textOffset + difficultyTop + paddingY)
        difficultySlider.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + paddingX, parametersFrame.bounds.y + difficultyTop + paddingY)
        confirmButton.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + 20, parametersFrame.bounds.y + parametersFrame.bounds.height - 60)
        cancelButton.setPosition(parametersFrame.bounds.x + parametersFrame.getOffsetX() + parametersFrame.bounds.width - 200, parametersFrame.bounds.y + parametersFrame.bounds.height - 60)
    end

    ---@public
    --- Fonction qui lance la sauvegarde des paramètres
    function parametersFrame.saveConfiguration()
        action({ fullScreen = fullScreenCheckbox.isChecked(), vsync = vsyncCheckbox.isChecked(), musicVolume = musicSlider.getValue(), soundVolume = soundSlider.getValue(), difficulty = difficultySlider.getValue(), maximized = love.window.isMaximized(), level = configuration:getLevel(), })
    end

    return parametersFrame
end

return ParametersFrame
