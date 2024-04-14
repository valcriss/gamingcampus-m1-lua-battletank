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

---@class GameLevel
GameLevel              = {}

GameLevel.new          = function()
    local gameLevel = Scene.new("GameLevel", 0)

    setmetatable(gameLevel, GameLevel)
    GameLevel.__index      = GameLevel

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    --- @type GameLevelData
    local gameLevelData    = GameLevelData.new()
    --- @type GameManager
    local gameManager      = GameManager.new(gameLevelData, function() gameLevel.onVictory() end, function() gameLevel.onDefeat() end)
    --- @type UIManager
    local uiManager        = UIManager.new(gameManager)
    --- @type DebugManager
    local debugManager     = DebugManager.new(gameManager).hide().disable()
    --- @type PauseMenuFrame
    local pauseMenuFrame   = PauseMenuFrame.new(function() gameLevel.resume() end, function() gameLevel.back() end, function(newValue) gameLevel.onDebugChanged(newValue) end).hide()
    --- @type SpriteSheetImage
    local transition       = SpriteSheetImage.new("transition", "assets/mainmenu/transition-100.png", 3, 8, 30, false, screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY(), nil, nil, nil, 1.01, nil, function() gameLevel.returnToMap() end).hide().disable()

    local dialogBackground = DialogBackground.new().hide().disable()
    --- @type HelpFrame
    local helpFrame        = HelpFrame.new(function() gameLevel.hideHelpMenu() end).hide().disable()
    --- @type Delay
    local delay            = Delay.new("showHelp").setDelay(0.2, function()
        gameLevel.showHelpMenu()
    end)
    local endGameUI        = EndGameUI.new(function(isVictory) gameLevel.endGame(isVictory) end)
    -- ---------------------------------------------
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

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    function gameLevel.pause()
        gameLevel.disableGameUpdate()
        gameLevel.showPauseMenu()
    end

    function gameLevel.unPause()
        gameLevel.enableGameUpdate()
        gameLevel.hidePauseMenu()
    end

    function gameLevel.disableGameUpdate()
        gameLevelData.disable()
        gameManager.disable()
        uiManager.disable()
    end

    function gameLevel.enableGameUpdate()
        gameLevelData.enable()
        gameManager.enable()
        uiManager.enable()
    end

    function gameLevel.showPauseMenu()
        dialogBackground.enable().show()
        pauseMenuFrame.appear()
    end

    function gameLevel.hidePauseMenu()
        dialogBackground.disable().hide()
        pauseMenuFrame.disappear()
    end

    function gameLevel.showHelpMenu()
        gameLevel.disableGameUpdate()
        dialogBackground.enable().show()
        helpFrame.appear()
    end

    function gameLevel.hideHelpMenu()
        gameLevel.enableGameUpdate()
        dialogBackground.disable().hide()
        helpFrame.disappear()
    end

    function gameLevel.resume()
        scenesManager:unPause()
    end

    function gameLevel.back()
        transition.enable().show()
    end

    function gameLevel.returnToMap()
        scenesManager:unPause()
        scenesManager:removeScene(gameLevel)
        scenesManager:addScene(LevelSelect.new())
    end

    function gameLevel.onDebugChanged(value)
        if value then
            debugManager.enable().show()
        else
            debugManager.disable().hide()
        end
    end

    function gameLevel.onVictory()
        gameLevel.disableGameUpdate()
        dialogBackground.enable().show()
        endGameUI.victory()
    end

    function gameLevel.onDefeat()
        gameLevel.disableGameUpdate()
        dialogBackground.enable().show()
        endGameUI.defeat()
    end

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
