local Component   = require "models.scenes.Component"
local Image       = require "models.images.Image"
local BitmapText  = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"
---@class Button
Button            = {}

---@param name string
---@param assetPath string
---@param assetOverPath string
---@param assetPressedPath string
---@param x number
---@param y number
---@param text string
---@param action function
Button.new        = function(name, assetPath, assetOverPath, assetPressedPath, x, y, text, action)
    local button = Component.new(name, x, y, 190, 49)

    setmetatable(button, Button)
    Button.__index           = Button

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local mouseIsOver        = false
    local mouseIsPressed     = false

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local buttonText         = BitmapText.new(button.name .. "_buttonText", "assets/ui/ui-18.fnt", text, "center", "center", button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
    local buttonImage        = Image.new(button.name .. "_buttonImage", assetPath, button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
    local buttonOverImage    = Image.new(button.name .. "_buttonOverImage", assetOverPath, button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
    local buttonPressedImage = Image.new(button.name .. "_buttonPressedImage", assetPressedPath, button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
    local soundEffect        = SoundEffect.new(button.name .. "_soundEffect", "assets/ui/switch2.mp3", "stream", false, false, configuration:getSoundVolume())

    button.addComponent(buttonImage)
    button.addComponent(buttonOverImage)
    button.addComponent(buttonPressedImage)
    button.addComponent(buttonText)
    button.addComponent(soundEffect)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    function button.update(_)
        soundEffect.setVolume(configuration:getSoundVolume())
        buttonImage.setPosition(button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
        buttonOverImage.setPosition(button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
        buttonPressedImage.setPosition(button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
        buttonText.setPosition(button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))

        local mouseX, mouseY = love.mouse.getPosition()
        if (mouseX == nil or mouseY == nil) then return end
        local isDown     = love.mouse.isDown(1)
        local wasPressed = not isDown and mouseIsPressed
        mouseIsPressed   = isDown
        mouseIsOver      = button.bounds.containsPoint(screenManager:ScaleUIValueX(mouseX), screenManager:ScaleUIValueY(mouseY))
        if not mouseIsOver then mouseIsPressed = false end
        if not mouseIsOver then
            buttonImage.show()
            buttonOverImage.hide()
            buttonPressedImage.hide()
        elseif mouseIsOver and not isDown then
            buttonImage.hide()
            buttonOverImage.show()
            buttonPressedImage.hide()
        elseif mouseIsOver and isDown then
            buttonImage.hide()
            buttonOverImage.hide()
            buttonPressedImage.show()
        end

        if (action == nil) then return end
        if mouseIsOver and wasPressed then
            soundEffect.play()
            action()
        end
    end

    return button
end

return Button
