local Component   = require "models.scenes.Component"
local Image       = require "models.images.Image"
local SoundEffect = require "models.audio.SoundEffect"
---@class SliderButton
SliderButton      = {}

SliderButton.new  = function(name, assetPath, x, y, action)
    local sliderButton = Component.new(
            name,
            {
                assetPath      = assetPath,
                mouseIsOver    = false,
                mouseIsPressed = false,
                action         = action
            },
            x,
            y,
            38,
            36
    )

    setmetatable(sliderButton, SliderButton)
    SliderButton.__index    = SliderButton

    local sliderButtonImage = Image.new(sliderButton.name .. "_sliderButtonImage", sliderButton.data.assetPath, sliderButton.bounds.x + (sliderButton.bounds.width / 2), sliderButton.bounds.y + (sliderButton.bounds.height / 2))
    local soundEffect       = SoundEffect.new(sliderButton.name .. "_soundEffect", "assets/ui/switch2.ogg", "static", false, false, configuration:getSoundVolume())

    sliderButton.addComponent(sliderButtonImage)
    sliderButton.addComponent(soundEffect)

    function sliderButton.update(_)
        soundEffect.setVolume(configuration:getSoundVolume())
        sliderButtonImage.setPosition(sliderButton.bounds.x + (sliderButton.bounds.width / 2), sliderButton.bounds.y + (sliderButton.bounds.height / 2))

        local mouseX, mouseY = love.mouse.getPosition()
        if (mouseX == nil or mouseY == nil) then return end
        local isDown                     = love.mouse.isDown(1)
        local wasPressed                 = not isDown and sliderButton.data.mouseIsPressed
        sliderButton.data.mouseIsPressed = isDown
        sliderButton.data.mouseIsOver    = sliderButton.bounds.containsPoint(mouseX, mouseY)
        if not sliderButton.data.mouseIsOver then sliderButton.data.mouseIsPressed = false end
        if sliderButton.data.mouseIsOver and wasPressed then
            soundEffect.play()
            if sliderButton.data.action ~= nil then
                sliderButton.data.action()
            end
        end
    end

    return sliderButton
end

return SliderButton
