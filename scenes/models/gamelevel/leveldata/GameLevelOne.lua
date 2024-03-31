local GameLevelData = require "scenes.models.gamelevel.leveldata.GameLevelData"
---@class GameLevelOne
GameLevelOne        = {}

GameLevelOne.new    = function()
    local gameLevelOne = GameLevelData.new(
            "GameLevelOne",
            {
                cell_1 = 3
            },
            {},
            1,
            1,
            50,
            50,
            1
    )

    setmetatable(gameLevelOne, GameLevelOne)
    GameLevelOne.__index = GameLevelOne

    return gameLevelOne
end

return GameLevelOne
