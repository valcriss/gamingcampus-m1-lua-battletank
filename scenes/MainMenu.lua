local Scene = require "models.scenes.Scene"
local MainMenuParallax = require "scenes.models.mainmenu.MainMenuParallax"
local MainMenuFrame = require "scenes.models.mainmenu.MainMenuFrame"
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
    local tank = SpriteSheetImage.new("assets/mainmenu/tank.png", 16, 80)
    local mainMenuTitle = BitmapText.new("assets/mainmenu/mainmenu-title.fnt")
    local backgroundMusic = SoundEffect.new("assets/mainmenu/mainmenu.mp3", "stream", true, true, 0.02)
    local mainMenuFrame = MainMenuFrame.new("Menu Principal", 75, 270, 300, 300)

    function mainMenu:load()
        mainMenuParallax:load()
        tank:load()
        mainMenuTitle:load()
        backgroundMusic:load()
        mainMenuFrame:load()
    end

    function mainMenu:update(dt)
        mainMenuParallax:update(dt)
        tank:update(dt)
        backgroundMusic:update(dt)
    end

    function mainMenu:draw()
        screenManager:clear(0, 0, 0)
        mainMenuParallax:draw()
        tank:draw(850, 600, 0, 0.5)
        mainMenuTitle:draw(screenManager:calculateCenterPointX(), 100, "Battle Tank", 0, "center", "center")
        mainMenuFrame:draw()
    end

    function mainMenu:unload()
        mainMenuParallax:unload()
        tank:unload()
        mainMenuTitle:unload()
        backgroundMusic:unload()
        mainMenuFrame:unload()
    end

    return mainMenu
end

return MainMenu
