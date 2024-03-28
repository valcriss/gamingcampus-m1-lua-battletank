local Scene = require "models.scenes.Scene"
local MainMenuParallax = require "scenes.models.mainmenu.MainMenuParallax"
local MainMenuFrame = require "scenes.models.mainmenu.MainMenuFrame"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"
local CreditsFrame = require "scenes.models.mainmenu.CreditsFrame"
local ParametersFrame = require "scenes.models.mainmenu.ParametersFrame"
local ConfirmationFrame = require "scenes.models.mainmenu.ConfirmationFrame"

---@class MainMenu
MainMenu = {}

MainMenu.new = function()
    local mainMenu = Scene.new("MainMenu", 0)

    setmetatable(mainMenu, MainMenu)
    MainMenu.__index = MainMenu
    local confirmationWith = 500
    local confirmationHeight = 150
    local tank = SpriteSheetImage.new("tank", "assets/mainmenu/tank.png", 34, 65, true, 750, 600, nil, nil, nil, 0.5)
    local backgroundMusic = SoundEffect.new("backgroundMusic", "assets/mainmenu/mainmenu.mp3", "stream", true, true, 0.02)
    local mainMenuTitle = BitmapText.new("mainMenuTitle", "assets/mainmenu/mainmenu-title.fnt", "Battle Tank", "center", "center", screenManager:calculateCenterPointX(), 100, nil, nil, nil)
    local mainMenuParallax = MainMenuParallax.new()
    local creditsFrame = CreditsFrame.new("creditsFrame", "Credits", 350, 200, 950, 500).hide().disable()
    local parametersFrame = ParametersFrame.new("parametersFrame", "Parametres", 350, 200, 950, 500).hide().disable()
    local confirmationFrame = ConfirmationFrame.new(
            "confirmationFrame",
            "Confirmation",
            screenManager:calculateCenterPointX() - confirmationWith / 2,
            screenManager:calculateCenterPointY() - confirmationHeight / 2,
            confirmationWith,
            confirmationHeight,
            nil,
            function(result)
                mainMenu.quitConfirm(result)
            end
    ).hide().disable()
    local mainMenuFrame = MainMenuFrame.new(
            "mainMenuFrame",
            "Menu Principal",
            75,
            270,
            220,
            260,
            function(button)
                mainMenu.OnButtonClicked(button)
            end
    )

    mainMenu.addComponent(mainMenuParallax).addComponent(mainMenuFrame).addComponent(tank).addComponent(backgroundMusic).addComponent(mainMenuTitle).addComponent(creditsFrame).addComponent(parametersFrame).addComponent(confirmationFrame)

    function mainMenu.OnButtonClicked(button)
        mainMenu.showFrame(button)
    end

    function mainMenu.showFrame(name)
        if name == "credits" then
            mainMenu.showFrameCredits()
        elseif name == "parameters" then
            mainMenu.showFrameParameters()
        elseif name == "quit" then
            mainMenu.showFrameQuit()
        end
    end

    function mainMenu.showFrameCredits()
        if parametersFrame.isVisible() then
            parametersFrame.disappear()
        end
        if confirmationFrame.isVisible() then
            confirmationFrame.disappear()
        end
        if creditsFrame.isVisible() then
            creditsFrame.disappear()
        else
            creditsFrame.appear()
        end
    end

    function mainMenu.showFrameParameters()
        if creditsFrame.isVisible() then
            creditsFrame.disappear()
        end
        if confirmationFrame.isVisible() then
            confirmationFrame.disappear()
        end
        if parametersFrame.isVisible() then
            parametersFrame.disappear()
        else
            parametersFrame.appear()
        end
    end

    function mainMenu.showFrameQuit()
        if creditsFrame.isVisible() then
            creditsFrame.disappear()
        end
        if parametersFrame.isVisible() then
            parametersFrame.disappear()
        end
        if confirmationFrame.isVisible() then
            confirmationFrame.disappear()
        else
            confirmationFrame.appear()
        end
    end

    function mainMenu.quitConfirm(result)
        if result then
            love.event.quit()
        else
            confirmationFrame.disappear()
        end
    end

    return mainMenu
end

return MainMenu
