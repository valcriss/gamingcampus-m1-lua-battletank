local Parallax = require "models.images.Parallax"
---@class MainMenuParallax
MainMenuParallax = {}

MainMenuParallax.new = function()
    local mainMenuParallax = {}

    setmetatable(mainMenuParallax, MainMenuParallax)
    MainMenuParallax.__index = MainMenuParallax

    local parallaxSpeed = 50
    local parallax1 = Parallax.new("assets/mainmenu/parallax1.png", parallaxSpeed * 2, "left")
    local parallax2 = Parallax.new("assets/mainmenu/parallax2.png", parallaxSpeed * 1.5, "left")
    local parallax3 = Parallax.new("assets/mainmenu/parallax3.png", parallaxSpeed, "left", 100)

    function mainMenuParallax:load()
        parallax1:load()
        parallax2:load()
        parallax3:load()
    end

    function mainMenuParallax:update(dt)
        parallax1:update(dt)
        parallax2:update(dt)
        parallax3:update(dt)
    end

    function mainMenuParallax:draw()
        parallax1:draw()
        parallax2:draw()
        parallax3:draw()
    end

    function mainMenuParallax:unload()
        parallax1:unload()
        parallax2:unload()
        parallax3:unload()
    end

    return mainMenuParallax
end

return MainMenuParallax
