local Scene        = require "models.scenes.Scene"
local GameLevelData = require "scenes.models.gameLevel.levelData.GameLevelData"

---@class GameLevel
GameLevel          = {}

GameLevel.new      = function()
    local gameLevel = Scene.new("GameLevel", 0)

    setmetatable(gameLevel, GameLevel)
    GameLevel.__index = GameLevel

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    --- @type GameLevelData
    local gameLevelData = GameLevelData.new()
    gameLevel.addComponent(gameLevelData)

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    return gameLevel
end

return GameLevel
