local Component = require "models.scenes.Component"
local ViewPort  = require "scenes.models.gameLevel.game.viewport.ViewPort"
local GameMap   = require "scenes.models.gameLevel.game.map.GameMap"
local FogOfWar  = require "scenes.models.gameLevel.game.map.FogOfWar"
local Parallax  = require "models.images.Parallax"

---@class GameManager
GameManager     = {}

--- @param gameLevelData GameLevelData
GameManager.new = function(gameLevelData)

    local gameManager = Component.new("GameManager")

    setmetatable(gameManager, GameManager)
    GameManager.__index      = GameManager

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local backgroundParallax = Parallax.new("background", "assets/gameLevel/water.png", 50, "left")
    local viewPort           = ViewPort.new(gameManager)
    local gameMap            = GameMap.new(gameManager)
    local fogOfWar           = FogOfWar.new(gameManager, true)

    gameManager.addComponent(backgroundParallax)
    gameManager.addComponent(viewPort)
    gameManager.addComponent(gameMap)
    gameManager.addComponent(fogOfWar)

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function gameManager.update(dt)
        local speed = 500
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            viewPort.horizontalMove(speed * dt)
        end
        if love.keyboard.isDown("left") or love.keyboard.isDown("q") then
            viewPort.horizontalMove(-speed * dt)
        end
        if love.keyboard.isDown("up") or love.keyboard.isDown("z") then
            viewPort.verticalMove(-speed * dt)
        end
        if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            viewPort.verticalMove(speed * dt)
        end
    end

    ---@public
    ---@return ViewPort
    function gameManager.getViewport()
        return viewPort
    end

    ---@public
    ---@return GameLevelData
    function gameManager.getGameLevelData()
        return gameLevelData
    end

    ---@public
    ---@return GameMap
    function gameManager.getGameMap()
        return gameMap
    end

    ---@public
    ---@return FogOfWar
    function gameManager.getFogOfWar()
        return fogOfWar
    end

    return gameManager
end

return GameManager
