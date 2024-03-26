local Scene = require "models.scenes.Scene"

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

    -- Classe functions

    function splashScreen:load()
    end

    function splashScreen:update(dt)
    end

    function splashScreen:draw()
    end

    function splashScreen:unload()
    end

    return splashScreen
end

return SplashScreen
