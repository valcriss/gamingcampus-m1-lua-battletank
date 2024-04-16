local Component   = require "models.scenes.Component"
local Image       = require "models.images.Image"
local SoundEffect = require "models.audio.SoundEffect"

---@class SliderButton
SliderButton      = {}

---@param name string
---@param assetPath string
---@param x number
---@param y number
---@param action function
SliderButton.new  = function(name, assetPath, x, y, action)
    local sliderButton = Component.new(name, x, y, 38, 36)

    setmetatable(sliderButton, SliderButton)
    SliderButton.__index    = SliderButton

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local mouseIsOver       = false
    local mouseIsPressed    = false

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------

    local sliderButtonImage = Image.new(sliderButton.name .. "_sliderButtonImage", assetPath, sliderButton.bounds.x + (sliderButton.bounds.width / 2), sliderButton.bounds.y + (sliderButton.bounds.height / 2))
    local soundEffect       = SoundEffect.new(sliderButton.name .. "_soundEffect", "assets/ui/switch2.mp3", "static", false, false, configuration:getSoundVolume())

    sliderButton.addComponent(sliderButtonImage)
    sliderButton.addComponent(soundEffect)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    function sliderButton.update(_)
        soundEffect.setVolume(configuration:getSoundVolume())
        sliderButtonImage.setPosition(sliderButton.bounds.x + (sliderButton.bounds.width / 2), sliderButton.bounds.y + (sliderButton.bounds.height / 2))

        local mouseX, mouseY = love.mouse.getPosition()
        if (mouseX == nil or mouseY == nil) then return end
        local isDown     = love.mouse.isDown(1)
        local wasPressed = not isDown and mouseIsPressed
        mouseIsPressed   = isDown
        mouseIsOver      = sliderButton.bounds.containsPoint(screenManager:ScaleUIValueX(mouseX), screenManager:ScaleUIValueY(mouseY))
        if not mouseIsOver then mouseIsPressed = false end
        if mouseIsOver and wasPressed then
            soundEffect.play()
            if action ~= nil then
                action()
            end
        end
    end

    return sliderButton
end

return SliderButton
