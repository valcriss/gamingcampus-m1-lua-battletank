local Scene         = require "models.scenes.Scene"
local GameLevelData = require "scenes.models.gameLevel.levelData.GameLevelData"
local GameManager   = require "scenes.models.gameLevel.game.GameManager"
local UIManager     = require "scenes.models.gameLevel.ui.UIManager"
local DebugManager  = require "scenes.models.gameLevel.debug.DebugManager"

---@class GameLevel
GameLevel           = {}

GameLevel.new       = function()
    local gameLevel = Scene.new("GameLevel", 0)

    setmetatable(gameLevel, GameLevel)
    GameLevel.__index   = GameLevel

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    --- @type GameLevelData
    local gameLevelData = GameLevelData.new()
    --- @type GameManager
    local gameManager   = GameManager.new(gameLevelData)
    --- @type UIManager
    local uiManager     = UIManager.new()
    --- @type DebugManager
    local debugManager  = DebugManager.new(gameManager)

    gameLevel.addComponent(gameLevelData)
    gameLevel.addComponent(gameManager)
    gameLevel.addComponent(uiManager)
    if DEBUG == true then
        gameLevel.addComponent(debugManager)
    end
    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    return gameLevel
end

return GameLevel
