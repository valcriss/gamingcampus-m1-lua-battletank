local JsonAsset   = require "models.tools.JsonAsset"
local Component   = require "models.scenes.Component"
---@class GameLevelData
GameLevelData     = {}

GameLevelData.new = function()
    local gameLevelData = Component.new("GameLevelData", {
        level = nil,
        tiles = {}
    })
    setmetatable(gameLevelData, GameLevelData)
    GameLevelData.__index = GameLevelData

    ---@public
    function gameLevelData.load()
        local levelAsset = gameLevelData.getLevelAsset()
        gameLevelData.data.level = JsonAsset:load(levelAsset)
        for key, value in pairs(gameLevelData.data.level.TilesAssets) do
            gameLevelData.data.tiles[key] = love.graphics.newImage(value)
        end
    end

    function gameLevelData.getLevelAsset()
        if configuration.getLevel() == 1 then return "assets/levels/level1.json" end
        return nil
    end

    return gameLevelData
end

return GameLevelData
