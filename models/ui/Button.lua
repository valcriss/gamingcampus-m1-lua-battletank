local Component = require "models.scenes.Component"
local Image = require "models.images.Image"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"
---@class Button
Button = {}

Button.new = function(name, assetPath, assetOverPath, assetPressedPath, x, y, text, action)
    local button =
        Component.new(
        name,
        {
            assetPath = assetPath,
            assetOverPath = assetOverPath,
            assetPressedPath = assetPressedPath,
            text = text,
            action = action,
            mouseIsOver = false,
            mouseIsPressed = false
        },
        x,
        y,
        190,
        49
    )

    setmetatable(button, Button)
    Button.__index = Button

    local buttonText = BitmapText.new(button.name .. "_buttonText", "assets/ui/ui-18.fnt", button.data.text, "center", "center", button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
    local buttonImage = Image.new(button.name .. "_buttonImage", button.data.assetPath, button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
    local buttonOverImage = Image.new(button.name .. "_buttonOverImage", button.data.assetOverPath, button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
    local buttonPressedImage = Image.new(button.name .. "_buttonPressedImage", button.data.assetPressedPath, button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
    local soundEffect = SoundEffect.new(button.name .. "_soundEffect", "assets/ui/switch2.ogg", "static", false, false, configuration:getSoundVolume())

    button.addComponent(buttonImage)
    button.addComponent(buttonOverImage)
    button.addComponent(buttonPressedImage)
    button.addComponent(buttonText)
    button.addComponent(soundEffect)

    function button.update(_)
        soundEffect.setVolume(configuration:getSoundVolume())
        buttonImage.setPosition(button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
        buttonOverImage.setPosition(button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
        buttonPressedImage.setPosition(button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))
        buttonText.setPosition(button.bounds.x + (button.bounds.width / 2), button.bounds.y + (button.bounds.height / 2))

        local mouseX, mouseY = love.mouse.getPosition()
        if (mouseX == nil or mouseY == nil) then
            return
        end
        local isDown = love.mouse.isDown(1)
        local wasPressed = not isDown and button.data.mouseIsPressed
        button.data.mouseIsPressed = isDown
        button.data.mouseIsOver = button.bounds.containsPoint(mouseX, mouseY)
        if not button.data.mouseIsOver then
            button.data.mouseIsPressed = false
        end

        if not button.data.mouseIsOver then
            buttonImage.show()
            buttonOverImage.hide()
            buttonPressedImage.hide()
        elseif button.data.mouseIsOver and not isDown then
            buttonImage.hide()
            buttonOverImage.show()
            buttonPressedImage.hide()
        elseif button.data.mouseIsOver and isDown then
            buttonImage.hide()
            buttonOverImage.hide()
            buttonPressedImage.show()
        end

        if (button.data.action == nil) then
            return
        end
        if button.data.mouseIsOver and wasPressed then
            soundEffect.play()
            button.data.action()
        end
    end

    return button
end

return Button
