local Scene = require "models.scenes.Scene"
local MainMenuParallax = require "scenes.models.mainmenu.MainMenuParallax"
local MainMenuFrame = require "scenes.models.mainmenu.MainMenuFrame"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"
local CreditsFrame = require "scenes.models.mainmenu.CreditsFrame"
local ParametersFrame = require "scenes.models.mainmenu.ParametersFrame"

---@class MainMenu
MainMenu = {}

MainMenu.new = function()
    local mainMenu = Scene:new("MainMenu", 0)

    setmetatable(mainMenu, MainMenu)
    MainMenu.__index = MainMenu

    local mainMenuParallax = MainMenuParallax.new()
    local tank = SpriteSheetImage.new("assets/mainmenu/tank.png", 34, 65)
    local mainMenuTitle = BitmapText.new("assets/mainmenu/mainmenu-title.fnt")
    local backgroundMusic = SoundEffect.new("assets/mainmenu/mainmenu.mp3", "stream", true, true, 0.02)
    local mainMenuFrame =
        MainMenuFrame.new(
        "Menu Principal",
        75,
        270,
        220,
        260,
        function(button)
            mainMenu:OnButtonClicked(button)
        end
    )
    local creditsFrame = CreditsFrame.new("Credits", 350, 200, 950, 500)
    local parametersFrame = ParametersFrame.new("Parametres", 350, 200, 950, 500)

    function mainMenu:load()
        mainMenuParallax:load()
        tank:load()
        mainMenuTitle:load()
        backgroundMusic:load()
        mainMenuFrame:load()
        creditsFrame:load()
        parametersFrame:load()
    end

    function mainMenu:update(dt)
        mainMenuParallax:update(dt)
        tank:update(dt)
        backgroundMusic:update(dt)
        mainMenuFrame:update(dt)
        creditsFrame:update(dt)
        parametersFrame:update(dt)
    end

    function mainMenu:draw()
        screenManager:clear(0, 0, 0)
        mainMenuParallax:draw()
        tank:draw(750, 600, 0, 0.5)
        mainMenuTitle:draw(screenManager:calculateCenterPointX(), 100, "Battle Tank", 0, "center", "center")
        mainMenuFrame:draw()
        creditsFrame:draw()
        parametersFrame:draw()
    end

    function mainMenu:unload()
        mainMenuParallax:unload()
        tank:unload()
        mainMenuTitle:unload()
        backgroundMusic:unload()
        mainMenuFrame:unload()
        creditsFrame:unload()
        parametersFrame:unload()
    end

    function mainMenu:OnButtonClicked(button)
        if button == "quit" then
            love.event.quit()
        elseif button == "credits" or button == "parameters" then
            mainMenu:showFrame(button)
        end
    end

    function mainMenu:showFrame(name)
        if name == "credits" then
            if parametersFrame:isVisible() then
                parametersFrame:hide()
            end
            if creditsFrame:isVisible() then
                creditsFrame:hide()
            else
                creditsFrame:show()
            end
        elseif name == "parameters" then
            if creditsFrame:isVisible() then
                creditsFrame:hide()
            end
            if parametersFrame:isVisible() then
                parametersFrame:hide()
            else
                parametersFrame:show()
            end
        end
    end

    return mainMenu
end

return MainMenu
