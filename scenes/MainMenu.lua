local Scene             = require "models.scenes.Scene"
local MainMenuParallax  = require "scenes.models.mainmenu.MainMenuParallax"
local MainMenuFrame     = require "scenes.models.mainmenu.MainMenuFrame"
local SpriteSheetImage  = require "models.images.SpriteSheetImage"
local BitmapText        = require "models.texts.BitmapText"
local SoundEffect       = require "models.audio.SoundEffect"
local CreditsFrame      = require "scenes.models.mainmenu.CreditsFrame"
local ParametersFrame   = require "scenes.models.mainmenu.ParametersFrame"
local ConfirmationFrame = require "scenes.models.mainmenu.ConfirmationFrame"
local LevelSelect       = require "scenes.LevelSelect"

---@class MainMenu
MainMenu                = {}

MainMenu.new            = function()
    local mainMenu = Scene.new("MainMenu", 0)

    setmetatable(mainMenu, MainMenu)
    MainMenu.__index         = MainMenu

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    local confirmationWith   = 500
    local confirmationHeight = 150

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------

    local tank               = SpriteSheetImage.new("tank", "assets/mainmenu/tank.png", 5, 6, 65, true, 750, 600, nil, nil, nil, 1)
    local transition         = SpriteSheetImage.new("transition", "assets/mainmenu/transition-100.png", 3, 8, 30, false, screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY(), nil, nil, nil, 1.01, nil, function() mainMenu.startGame() end).hide().disable()
    local mainMenuTitle      = BitmapText.new("mainMenuTitle", "assets/mainmenu/mainmenu-title.fnt", "Battle Tank", "center", "center", screenManager:calculateCenterPointX(), 100, nil, nil, nil)
    local mainMenuFrame      = MainMenuFrame.new("mainMenuFrame", "Menu Principal", 75, 270, 220, 260, function(button) mainMenu.OnButtonClicked(button) end)
    local mainMenuParallax   = MainMenuParallax.new()
    local creditsFrame       = CreditsFrame.new("creditsFrame", "Credits", 430, 200, 810, 500).hide().disable()
    local parametersFrame    = ParametersFrame.new("parametersFrame", "Parametres", 600, 250, 450, 400, nil, function(data) mainMenu.saveParameters(data) end).hide().disable()
    local confirmationFrame  = ConfirmationFrame.new("confirmationFrame", "Confirmation", screenManager:calculateCenterPointX() - confirmationWith / 2 + 125, screenManager:calculateCenterPointY() - confirmationHeight / 2, confirmationWith, confirmationHeight, nil, function(result) mainMenu.quitConfirm(result) end).hide().disable()
    local transitionEffect   = SoundEffect.new("transitionEffect", "assets/ui/ascending.mp3", "static", false, false, configuration:getSoundVolume())
    local backgroundMusic    = SoundEffect.new("backgroundMusic", "assets/mainmenu/mainmenu.mp3", "stream", true, true, configuration:getMusicVolume())

    mainMenu.addComponent(mainMenuParallax)
    mainMenu.addComponent(mainMenuFrame)
    mainMenu.addComponent(tank)
    mainMenu.addComponent(backgroundMusic)
    mainMenu.addComponent(mainMenuTitle)
    mainMenu.addComponent(creditsFrame)
    mainMenu.addComponent(parametersFrame)
    mainMenu.addComponent(confirmationFrame)
    mainMenu.addComponent(transition)
    mainMenu.addComponent(transitionEffect)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    --- Fonction qui gère les événements aux clics sur les boutons
    ---@param button string
    function mainMenu.OnButtonClicked(button)
        if button == "credits" then
            mainMenu.showFrameCredits()
        elseif button == "parameters" then
            mainMenu.showFrameParameters()
        elseif button == "quit" then
            mainMenu.showFrameQuit()
        elseif button == "start" then
            transition.show()
            transitionEffect.play()
            transition.enable()
        end
    end

    ---@public
    --- Fonction qui gère l'affichage de la fenetre de credits
    function mainMenu.showFrameCredits()
        if parametersFrame.isVisible() then parametersFrame.disappear() end
        if confirmationFrame.isVisible() then confirmationFrame.disappear() end
        if creditsFrame.isVisible() then
            creditsFrame.disappear()
        else
            creditsFrame.appear()
        end
    end

    ---@public
    --- Fonction qui gère l'affichage de la fenetre de paramètres
    function mainMenu.showFrameParameters()
        if creditsFrame.isVisible() then creditsFrame.disappear() end
        if confirmationFrame.isVisible() then confirmationFrame.disappear() end
        if parametersFrame.isVisible() then
            parametersFrame.disappear()
        else
            parametersFrame.appear()
        end
    end

    ---@public
    --- Fonction qui gère l'affichage de la fenetre de quitter
    function mainMenu.showFrameQuit()
        if creditsFrame.isVisible() then creditsFrame.disappear() end
        if parametersFrame.isVisible() then parametersFrame.disappear() end
        if confirmationFrame.isVisible() then
            confirmationFrame.disappear()
        else
            confirmationFrame.appear()
        end
    end

    ---@public
    --- Fonction qui gère la confirmation de quitter
    function mainMenu.quitConfirm(result)
        if result then
            love.event.quit()
        else
            confirmationFrame.disappear()
        end
    end

    ---@public
    --- Fonction qui gère la sauvegarde des paramètres
    ---@param data table
    function mainMenu.saveParameters(data)
        if data ~= nil then
            local needReload = configuration:setConfiguration(data)
            if needReload then screenManager:reload() end
            backgroundMusic.setVolume(configuration:getMusicVolume())
            transitionEffect.setVolume(configuration:getSoundVolume())
        end
        parametersFrame.disappear()
    end

    ---@public
    --- Fonction qui permet de lancer la scene de selection de niveau
    function mainMenu.startGame()
        scenesManager:removeScene(mainMenu)
        scenesManager:addScene(LevelSelect.new())
    end

    return mainMenu
end

return MainMenu
