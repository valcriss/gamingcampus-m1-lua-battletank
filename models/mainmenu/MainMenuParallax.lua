local Component      = require "framework.scenes.Component"
local Parallax       = require "framework.images.Parallax"
---@class MainMenuParallax
MainMenuParallax     = {}

MainMenuParallax.new = function()
    local mainMenuParallax = Component.new("MainMenuParallax")

    setmetatable(mainMenuParallax, MainMenuParallax)
    MainMenuParallax.__index = MainMenuParallax

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local parallaxSpeed      = 50

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local parallax1          = Parallax.new("parallax1", "assets/mainmenu/parallax1.png", parallaxSpeed * 2, "left")
    local parallax2          = Parallax.new("parallax2", "assets/mainmenu/parallax2.png", parallaxSpeed * 1.5, "left")
    local parallax3          = Parallax.new("parallax3", "assets/mainmenu/parallax3.png", parallaxSpeed, "left", 100)

    mainMenuParallax.addComponent(parallax1)
    mainMenuParallax.addComponent(parallax2)
    mainMenuParallax.addComponent(parallax3)

    return mainMenuParallax
end

return MainMenuParallax
