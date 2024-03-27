local Scene = require "models.scenes.Scene"
local MainMenuParallax = require "scenes.models.mainmenu.MainMenuParallax"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"

---@class MainMenu
MainMenu = {}

MainMenu.new = function()
    local mainMenu = Scene:new("MainMenu", 0)

    setmetatable(mainMenu, MainMenu)
    MainMenu.__index = MainMenu

    local mainMenuParallax = MainMenuParallax.new()
    local tank = SpriteSheetImage.new("assets/mainmenu/tank.png", 7, 50)
    local mainMenuTitle = BitmapText.new("assets/mainmenu/mainmenu-title.fnt")
    local backgroundMusic = SoundEffect.new("assets/mainmenu/mainmenu.mp3", "stream", true, true, 0.02)

    function mainMenu:load()
        mainMenuParallax:load()
        tank:load()
        mainMenuTitle:load()
        backgroundMusic:load()
    end

    function mainMenu:update(dt)
        mainMenuParallax:update(dt)
        tank:update(dt)
        backgroundMusic:update(dt)
    end

    function mainMenu:draw()
        screenManager:clear(0, 0, 0)
        mainMenuParallax:draw()
        tank:draw(900, 550, 0, 0.7)
        mainMenuTitle:draw(screenManager:calculateCenterPointX(), 100, "Battle Tank", 0, "center", "center")
    end

    function mainMenu:unload()
        mainMenuParallax:unload()
        tank:unload()
        mainMenuTitle:unload()
        backgroundMusic:unload()
    end

    return mainMenu
end

return MainMenu
