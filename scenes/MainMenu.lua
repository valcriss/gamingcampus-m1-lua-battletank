local Scene = require "models.scenes.Scene"
local MainMenuParallax = require "scenes.models.mainmenu.MainMenuParallax"

---@class MainMenu
MainMenu = {}

MainMenu.new = function()
    local mainMenu = Scene:new("MainMenu", 0)

    setmetatable(mainMenu, MainMenu)
    MainMenu.__index = MainMenu

    local mainMenuParallax = MainMenuParallax.new()

    function mainMenu:load()
        mainMenuParallax:load()
    end

    function mainMenu:update(dt)
        mainMenuParallax:update(dt)
    end

    function mainMenu:draw()
        screenManager:clear(0, 0, 0)
        mainMenuParallax:draw()
    end

    function mainMenu:unload()
        mainMenuParallax:unload()
    end

    return mainMenu
end

return MainMenu
