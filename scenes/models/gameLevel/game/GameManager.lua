local Component = require "models.scenes.Component"
local ViewPort  = require "scenes.models.gameLevel.game.viewport.ViewPort"
local GameMap   = require "scenes.models.gameLevel.game.map.GameMap"
local FogOfWar  = require "scenes.models.gameLevel.game.map.FogOfWar"
local Parallax  = require "models.images.Parallax"
local Player    = require "scenes.models.gameLevel.game.entities.Player"

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
    local player             = Player.new(gameManager)
    local fogOfWar           = FogOfWar.new(gameManager, true)

    gameManager.addComponent(backgroundParallax)
    gameManager.addComponent(viewPort)
    gameManager.addComponent(gameMap)
    gameManager.addComponent(player)

    if FOG_OF_WAR then
        gameManager.addComponent(fogOfWar)
    end

    local units = {}

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function gameManager.load()
        table.insert(units, player)
    end

    ---@public
    function gameManager.update(dt)
        local right  = love.keyboard.isDown("right") or love.keyboard.isDown("d")
        local left   = love.keyboard.isDown("left") or love.keyboard.isDown("q") or love.keyboard.isDown("a")
        local top    = love.keyboard.isDown("up") or love.keyboard.isDown("z") or love.keyboard.isDown("w")
        local bottom = love.keyboard.isDown("down") or love.keyboard.isDown("s")

        viewPort.playerInputs(dt, top, left, bottom, right)
        player.playerInputs(dt, top, left, bottom, right)
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

    ---@public
    ---@return Player
    function gameManager.getPlayer()
        return player
    end

    ---@public
    ---@return table
    function gameManager.getUnits()
        return units
    end

    return gameManager
end

return GameManager
