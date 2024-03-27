local Image = require "models.images.Image"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"
---@class Button
Button = {}

Button.new = function(assetPath, assetOverPath, assetPressedPath, x, y, text, action)
    local button = {
        assetPath = assetPath,
        assetOverPath = assetOverPath,
        assetPressedPath = assetPressedPath,
        x = x,
        y = y,
        text = text,
        action = action,
        width = 190,
        height = 49,
        mouseIsOver = false,
        mouseIsPressed = false
    }

    setmetatable(button, Button)
    Button.__index = Button

    local buttonText = BitmapText.new("assets/ui/ui-18.fnt")
    local buttonImage = Image.new(button.assetPath)
    local buttonOverImage = Image.new(button.assetOverPath)
    local buttonPressedImage = Image.new(button.assetPressedPath)
    local soundEffect = SoundEffect.new("assets/ui/switch2.ogg", "static", false, false)

    function button:load()
        buttonText:load()
        buttonImage:load()
        buttonOverImage:load()
        buttonPressedImage:load()
        soundEffect:load()
    end

    function button:update(dt)
        local x, y = love.mouse.getPosition()
        if (x == nil or y == nil) then
            return
        end
        local isDown = love.mouse.isDown(1)
        local wasPressed = not isDown and button.mouseIsPressed
        button.mouseIsPressed = isDown
        local scaledX = screenManager:ScaleValueX(button.x)
        local scaledWidth = screenManager:ScaleValueX(button.width)
        local scaledY = screenManager:ScaleValueY(button.y)
        local scaledHeight = screenManager:ScaleValueY(button.height)
        button.mouseIsOver = (x >= scaledX and x <= scaledX + scaledWidth and y >= scaledY and y <= scaledY + scaledHeight)
        if not button.mouseIsOver then
            button.mouseIsPressed = false
        end
        if (button.action == nil) then
            return
        end
        if button.mouseIsOver and wasPressed then
            soundEffect:play()
            button.action()
        end
    end

    function button:draw()
        if button.mouseIsPressed then
            buttonPressedImage:draw(button.x + (button.width / 2), button.y + (button.height / 2))
        elseif button.mouseIsOver then
            buttonOverImage:draw(button.x + (button.width / 2), button.y + (button.height / 2))
        else
            buttonImage:draw(button.x + (button.width / 2), button.y + (button.height / 2))
        end

        buttonText:draw(button.x + (button.width / 2), button.y + (button.height / 2), button.text, 0, "center", "center")
    end

    function button:unload()
        buttonText:unload()
        buttonImage:unload()
        buttonOverImage:unload()
        buttonPressedImage:unload()
        soundEffect:unload()
    end

    return button
end

return Button
