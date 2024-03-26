local Scene = require "models.scenes.Scene"
local Image = require "models.images.Image"
local BitmapText = require "models.texts.BitmapText"

---@class SplashScreen
SplashScreen = {}

---@param name string
---@param order number
SplashScreen.new = function(name, order --[[optional]])
    order = order or 0
    local splashScreen = Scene:new(name, order)

    setmetatable(splashScreen, SplashScreen)
    SplashScreen.__index = SplashScreen

    -- Classe Properties
    local logo = Image.new("assets/logo-brainlimits.png")
    local title = BitmapText.new("assets/title-font.fnt")

    -- Classe functions

    function splashScreen:load()
        logo:load()
        title:load()
    end

    function splashScreen:update(dt)
    end

    function splashScreen:draw()
        screenManager:clear(128, 180, 255)
        logo:draw(screenManager.calculateCenterPointX(), screenManager.calculateCenterPointY())
        title:draw(screenManager.calculateCenterPointX(), 650, "Mind Limits", 0, "center", "center")
    end

    function splashScreen:unload()
        logo:unload()
        title:unload()
    end

    return splashScreen
end

return SplashScreen
