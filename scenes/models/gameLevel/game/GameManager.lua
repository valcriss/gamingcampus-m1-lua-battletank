local Component = require "models.scenes.Component"
local ViewPort  = require "scenes.models.gameLevel.game.viewport.ViewPort"
local GameMap   = require "scenes.models.gameLevel.game.map.GameMap"
local FogOfWar  = require "scenes.models.gameLevel.game.map.FogOfWar"
local Parallax  = require "models.images.Parallax"
local Player    = require "scenes.models.gameLevel.game.entities.Player"
local MainTower = require "scenes.models.gameLevel.game.entities.MainTower"
local Enemy     = require "scenes.models.gameLevel.game.entities.Enemy"
local Flag      = require "scenes.models.gameLevel.game.entities.Flag"

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
    local mainTower1         = MainTower.new("mainTower1", gameManager, 1)
    local mainTower2         = MainTower.new("mainTower2", gameManager, 2)
    local fogOfWar           = FogOfWar.new(gameManager, true)

    gameManager.addComponent(backgroundParallax)
    gameManager.addComponent(viewPort)
    gameManager.addComponent(gameMap)

    local units = {}

    if FOG_OF_WAR then
        gameManager.addComponent(fogOfWar)
    end

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function gameManager.load()
        table.insert(units, player)
        table.insert(units, mainTower1)
        table.insert(units, mainTower2)
        -- Chargement des enemies
        for index = 1, #gameLevelData.data.level.EnemyStarts do
            local enemyPosition = gameLevelData.data.level.EnemyStarts[index]
            local enemy         = Enemy.new(enemyPosition, gameManager)
            gameManager.addComponent(enemy)
            table.insert(units, enemy)
        end
        -- Chargement des flags
        for index = 1, #gameLevelData.data.level.Flags do
            local flagPosition = gameLevelData.data.level.Flags[index]
            local flag         = Flag.new(gameManager, flagPosition, index)
            gameManager.addComponent(flag)
            table.insert(units, flag)
        end
        gameManager.addComponent(mainTower1)
        gameManager.addComponent(mainTower2)
        gameManager.addComponent(player)

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

    -- ---------------------------------------------
    -- Getters Functions
    -- ---------------------------------------------

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

    -- ---------------------------------------------
    -- Event Handlers Functions
    -- ---------------------------------------------
    function gameManager.onUnitTakeDamage(unit, damage, fromGroup)
        unit.takeDamage(damage, fromGroup)
    end

    function gameManager.onUnitDead(unit, fromGroup)
        if unit.getType() == "Flag" then
            unit.fullHealth()
            gameManager.onFlagCaptured(unit, fromGroup)
        elseif unit.getType() == "Tank" then
            unit.fullHealth()
            unit.setFrozen(10)
        end
    end

    function gameManager.onFlagCaptured(unit, fromGroup)
        unit.setGroup(fromGroup)
    end

    return gameManager
end

return GameManager
