local Scene = require "models.scenes.Scene"
local MainMenuParallax = require "scenes.models.mainmenu.MainMenuParallax"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"
local Frame = require "models.ui.Frame"

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
    local frame = Frame.new("assets/ui/grey_panel.png", 10)
    local blueFrame = Frame.new("assets/ui/blue_panel.png", 10)
    local frameTitle = BitmapText.new("assets/ui/ui-18.fnt")

    function mainMenu:load()
        mainMenuParallax:load()
        tank:load()
        mainMenuTitle:load()
        backgroundMusic:load()
        frameTitle:load()
        blueFrame:load()
        frame:load()
    end

    function mainMenu:update(dt)
        mainMenuParallax:update(dt)
        tank:update(dt)
        backgroundMusic:update(dt)
    end

    function mainMenu:draw()
        screenManager:clear(0, 0, 0)
        mainMenuParallax:draw()
        tank:draw(850, 550, 0, 0.7)
        mainMenuTitle:draw(screenManager:calculateCenterPointX(), 100, "Battle Tank", 0, "center", "center")
        blueFrame:draw(75, 170, 300, 50)
        frameTitle:draw(230, 187, "Menu Principal", 0, "center", "center")
        frame:draw(75, 200, 300, 400)
    end

    function mainMenu:unload()
        mainMenuParallax:unload()
        tank:unload()
        mainMenuTitle:unload()
        backgroundMusic:unload()
        frameTitle:unload()
        blueFrame:unload()
        frame:unload()
    end

    return mainMenu
end

return MainMenu
