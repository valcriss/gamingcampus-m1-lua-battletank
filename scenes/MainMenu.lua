local Scene = require "models.scenes.Scene"

---@class MainMenu
MainMenu = {}

MainMenu.new = function()
    local mainMenu = Scene:new("MainMenu", 0)

    setmetatable(mainMenu, MainMenu)
    MainMenu.__index = MainMenu

    -- Classe Properties

    -- Classe functions

    function mainMenu:load()
    end

    function mainMenu:update(dt)
    end

    function mainMenu:draw()
        screenManager:clear(0, 0, 0)
    end

    function mainMenu:unload()
    end

    return mainMenu
end

return MainMenu
