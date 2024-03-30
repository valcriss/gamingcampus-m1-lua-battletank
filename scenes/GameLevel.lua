local Scene   = require "models.scenes.Scene"

---@class GameLevel
GameLevel     = {}

GameLevel.new = function()
    local gameLevel = Scene.new("GameLevel", 0)

    setmetatable(gameLevel, GameLevel)
    GameLevel.__index = GameLevel

    function gameLevel.update(_)
    end

    return gameLevel
end

return GameLevel
