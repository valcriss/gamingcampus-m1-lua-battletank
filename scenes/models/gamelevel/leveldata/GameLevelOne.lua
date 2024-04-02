local GameLevelData = require "scenes.models.gamelevel.leveldata.GameLevelData"
---@class GameLevelOne
GameLevelOne        = {}

GameLevelOne.new    = function()
    local gameLevelOne = GameLevelData.new(
            "GameLevelOne",
            "assets/gamelevel/level1.json",
            12,
            10,
            1,
            { x = 9, y = 7 },
            { x = 42, y = 41 }
    )

    setmetatable(gameLevelOne, GameLevelOne)
    GameLevelOne.__index = GameLevelOne

    return gameLevelOne
end

return GameLevelOne
