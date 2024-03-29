local MenuFrame = require "scenes.models.mainmenu.MenuFrame"
local BitmapText = require "models.texts.BitmapText"
local CheckBox = require "models.ui.CheckBox"
local Slider = require "models.ui.Slider"
local Button = require "models.ui.Button"

---@class ParametersFrame
ParametersFrame = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
ParametersFrame.new = function(name, title, x, y, width, height, moveSpeed, action)
    local parametersFrame = MenuFrame.new(name, title, x, y, width, height, moveSpeed, "assets/ui/red_panel.png", { action = action }, true)

    setmetatable(parametersFrame, ParametersFrame)
    ParametersFrame.__index = ParametersFrame

    local fullScreenLabel = BitmapText.new(parametersFrame.name .. "_fullScreenLabel", "assets/ui/roboto-bold-black.fnt", "Plein Ecran", "left")
    local vSyncLabel = BitmapText.new(parametersFrame.name .. "_vSyncLabel", "assets/ui/roboto-bold-black.fnt", "Vsync", "left")
    local musicLabel = BitmapText.new(parametersFrame.name .. "_musicLabel", "assets/ui/roboto-bold-black.fnt", "Volume Musique", "left")
    local soundLabel = BitmapText.new(parametersFrame.name .. "_soundLabel", "assets/ui/roboto-bold-black.fnt", "Volume Effets", "left")
    local difficultyLabel = BitmapText.new(parametersFrame.name .. "_difficultyLabel", "assets/ui/roboto-bold-black.fnt", "Difficulté", "left")

    local fullScreenCheckbox = CheckBox.new(parametersFrame.name .. "_fullScreenCheckbox", "assets/ui/checkbox_unchecked.png", "assets/ui/checkbox_checked.png", 0, 0)
    local vsyncCheckbox = CheckBox.new(parametersFrame.name .. "_vsyncCheckbox", "assets/ui/checkbox_unchecked.png", "assets/ui/checkbox_checked.png", 0, 0)

    local musicSlider = Slider.new(parametersFrame.name .. "_musicSlider", 0, 0, configuration:getMusicVolume())
    local soundSlider = Slider.new(parametersFrame.name .. "_soundSlider", 0, 0, configuration:getSoundVolume())
    local difficultySlider = Slider.new(parametersFrame.name .. "_difficultySlider", 0, 0, configuration:getDifficulty())

    local confirmButton = Button.new("confirmButton",
            "assets/ui/green_button00.png",
            "assets/ui/green_button04.png",
            "assets/ui/green_button03.png",
            parametersFrame.bounds.x + 40,
            parametersFrame.bounds.y + parametersFrame.bounds.height - 60,
            "Sauvegarder",
            function()
                windowX, windowY, displayIndex = love.window.getPosition()
                parametersFrame.data.action({
                    fullScreen = fullScreenCheckbox.isChecked(),
                    vsync = vsyncCheckbox.isChecked(),
                    musicVolume = musicSlider.getValue(),
                    soundVolume = soundSlider.getValue(),
                    difficulty = difficultySlider.getValue(),
                    maximized = love.window.isMaximized(),
                    windowX = windowX,
                    windowY = windowY,
                    windowWidth = love.graphics.getWidth(),
                    windowHeight = love.graphics.getHeight()
                })
            end
    )
    local cancelButton = Button.new("confirmButton",
            "assets/ui/red_button11.png",
            "assets/ui/red_button01.png",
            "assets/ui/red_button02.png",
            parametersFrame.bounds.x + parametersFrame.bounds.width - 180,
            parametersFrame.bounds.y + parametersFrame.bounds.height - 60,
            "Annuler",
            function()
                parametersFrame.data.action()
            end
    )

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

    function parametersFrame.update(dt)
        parametersFrame.updateAnimation(dt)
        local paddingY = 20
        local paddingX = 150
        local textOffset = 7
        local fullScreenTop = paddingY
        local vSyncTop = fullScreenTop + fullScreenLabel.getHeight() + paddingY
        local musicTop = paddingY + vSyncTop + vSyncLabel.getHeight() + paddingY
        local soundTop = paddingY + musicTop + vSyncLabel.getHeight() + paddingY
        local difficultyTop = paddingY + soundTop + vSyncLabel.getHeight() + paddingY
        fullScreenLabel.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + 20, parametersFrame.bounds.y + textOffset + fullScreenTop)
        fullScreenCheckbox.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + paddingX, parametersFrame.bounds.y + fullScreenTop)
        vSyncLabel.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + 20, parametersFrame.bounds.y + textOffset + vSyncTop + paddingY)
        vsyncCheckbox.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + paddingX, parametersFrame.bounds.y + vSyncTop + paddingY)
        musicLabel.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + 20, parametersFrame.bounds.y + textOffset + musicTop + paddingY)
        musicSlider.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + paddingX, parametersFrame.bounds.y + musicTop + paddingY)

        soundLabel.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + 20, parametersFrame.bounds.y + textOffset + soundTop + paddingY)
        soundSlider.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + paddingX, parametersFrame.bounds.y + soundTop + paddingY)

        difficultyLabel.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + 20, parametersFrame.bounds.y + textOffset + difficultyTop + paddingY)
        difficultySlider.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + paddingX, parametersFrame.bounds.y + difficultyTop + paddingY)

        confirmButton.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + 20, parametersFrame.bounds.y + parametersFrame.bounds.height - 60)
        cancelButton.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + parametersFrame.bounds.width - 200, parametersFrame.bounds.y + parametersFrame.bounds.height - 60)
    end

    return parametersFrame
end

return ParametersFrame
