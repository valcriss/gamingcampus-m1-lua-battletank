local Scene            = require "models.scenes.Scene"
local GameLevelData    = require "scenes.models.gameLevel.levelData.GameLevelData"
local GameManager      = require "scenes.models.gameLevel.game.GameManager"
local UIManager        = require "scenes.models.gameLevel.ui.UIManager"
local DebugManager     = require "scenes.models.gameLevel.debug.DebugManager"
local PauseMenuFrame   = require "scenes.models.gameLevel.pause.PauseMenuFrame"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local DialogBackground = require "models.ui.DialogBackground"
local HelpFrame        = require "scenes.models.gameLevel.pause.HelpFrame"
local Delay            = require "models.tools.Delay"
local EndGameUI        = require "scenes.models.gameLevel.ui.EndGameUI"
local SoundEffect      = require "models.audio.SoundEffect"

---@class GameLevel
GameLevel              = {}

GameLevel.new          = function()
    local gameLevel = Scene.new("GameLevel", 0)

    setmetatable(gameLevel, GameLevel)
    GameLevel.__index      = GameLevel

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local gameLevelData    = GameLevelData.new()
    local gameManager      = GameManager.new(gameLevelData, function() gameLevel.onVictory() end, function() gameLevel.onDefeat() end)
    local uiManager        = UIManager.new(gameManager)
    local debugManager     = DebugManager.new(gameManager).hide().disable()
    local pauseMenuFrame   = PauseMenuFrame.new(function() gameLevel.resume() end, function() gameLevel.back() end, function(newValue) gameLevel.onDebugChanged(newValue) end).hide()
    local transition       = SpriteSheetImage.new("transition", "assets/mainmenu/transition-100.png", 3, 8, 30, false, screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY(), nil, nil, nil, 1.01, nil, function() gameLevel.returnToMap() end).hide().disable()
    local dialogBackground = DialogBackground.new().hide().disable()
    local helpFrame        = HelpFrame.new(function() gameLevel.hideHelpMenu() end).hide().disable()
    local delay            = Delay.new("showHelp").setDelay(0.2, function() gameLevel.showHelpMenu() end)
    local endGameUI        = EndGameUI.new(function(isVictory) gameLevel.endGame(isVictory) end)
    local backgroundMusic  = SoundEffect.new("background", "assets/gameLevel/music/map-" .. configuration:getLevel() .. ".mp3", "stream", true, true, configuration:getMusicVolume())
    local victorySound     = SoundEffect.new("victorySound", "assets/gameLevel/sound/victory.mp3", "static", false, false, configuration:getSoundVolume())
    local defeatSound      = SoundEffect.new("defeatSound", "assets/gameLevel/sound/defeat.mp3", "static", false, false, configuration:getSoundVolume())

    gameLevel.addComponent(gameLevelData)
    gameLevel.addComponent(gameManager)
    gameLevel.addComponent(uiManager)
    gameLevel.addComponent(debugManager)
    gameLevel.addComponent(dialogBackground)
    gameLevel.addComponent(pauseMenuFrame)
    gameLevel.addComponent(helpFrame)
    gameLevel.addComponent(transition)
    gameLevel.addComponent(delay)
    gameLevel.addComponent(endGameUI)
    gameLevel.addComponent(backgroundMusic)
    gameLevel.addComponent(victorySound)
    gameLevel.addComponent(defeatSound)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    --- Fonction déclenchée lors de la pause de la scene
    function gameLevel.pause()
        gameLevel.disableGameUpdate()
        gameLevel.showPauseMenu()
    end

    ---@public
    --- Fonction déclenchée lors de la sortie de la pause de la scene
    function gameLevel.unPause()
        gameLevel.enableGameUpdate()
        gameLevel.hidePauseMenu()
    end

    ---@public
    --- Fonction qui désactive les mises a jour du jeu
    function gameLevel.disableGameUpdate()
        gameLevelData.disable()
        gameManager.disable()
        uiManager.disable()
        backgroundMusic.pause()
    end

    ---@public
    --- Fonction qui active les mises a jour du jeu
    function gameLevel.enableGameUpdate()
        gameLevelData.enable()
        gameManager.enable()
        uiManager.enable()
        backgroundMusic.resume()
    end

    ---@public
    --- Fonction qui affiche le menu de pause
    function gameLevel.showPauseMenu()
        dialogBackground.enable().show()
        pauseMenuFrame.appear()
    end

    ---@public
    --- Fonction qui cache le menu de pause
    function gameLevel.hidePauseMenu()
        dialogBackground.disable().hide()
        pauseMenuFrame.disappear()
    end

    ---@public
    --- Fonction qui affiche le menu d'aide
    function gameLevel.showHelpMenu()
        gameLevel.disableGameUpdate()
        dialogBackground.enable().show()
        helpFrame.appear()
    end

    ---@public
    --- Fonction qui cache le menu d'aide
    function gameLevel.hideHelpMenu()
        gameLevel.enableGameUpdate()
        dialogBackground.disable().hide()
        helpFrame.disappear()
    end

    ---@public
    --- Fonction qui permet de redemarrer le jeu
    function gameLevel.resume()
        scenesManager:unPause()
    end

    ---@public
    --- Fonction qui permet de lancer la transition avant de retourner a la selection du niveau
    function gameLevel.back()
        transition.enable().show()
    end

    ---@public
    --- Fonction qui permet de retourner a la selection du niveau
    function gameLevel.returnToMap()
        scenesManager:unPause()
        scenesManager:removeScene(gameLevel)
        scenesManager:addScene(LevelSelect.new())
    end

    ---@public
    --- Fonction déclenché lors du changement de valeur de la case a cocher de debug
    ---@param value boolean
    function gameLevel.onDebugChanged(value)
        if value then
            debugManager.enable().show()
        else
            debugManager.disable().hide()
        end
    end

    ---@public
    --- Fonction qui gère l'affichage de la fenetre de fin de jeu en cas de victoire
    function gameLevel.onVictory()
        gameLevel.disableGameUpdate()
        dialogBackground.enable().show()
        endGameUI.victory()
        victorySound.play()
    end

    ---@public
    --- Fonction qui gère l'affichage de la fenetre de fin de jeu en cas de défaite
    function gameLevel.onDefeat()
        gameLevel.disableGameUpdate()
        dialogBackground.enable().show()
        endGameUI.defeat()
        defeatSound.play()
    end

    ---@public
    --- Fonction déclenchée lors de la fin du jeu en cas de victoire ou de défaite
    function gameLevel.endGame(isVictory)
        if isVictory then
            configuration:changeLevel()
        end
        scenesManager:removeScene(gameLevel)
        scenesManager:addScene(LevelSelect.new())
    end

    return gameLevel
end

return GameLevel
