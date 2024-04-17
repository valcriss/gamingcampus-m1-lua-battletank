local Component        = require "framework.scenes.Component"
local ViewPort         = require "models.gameLevel.game.viewport.ViewPort"
local GameMap          = require "models.gameLevel.game.map.GameMap"
local FogOfWar         = require "models.gameLevel.game.map.FogOfWar"
local Parallax         = require "framework.images.Parallax"
local Player           = require "models.gameLevel.game.entities.Player"
local MainTower        = require "models.gameLevel.game.entities.MainTower"
local Enemy            = require "models.gameLevel.game.entities.Enemy"
local Flag             = require "models.gameLevel.game.entities.Flag"
local PathFinding      = require "models.gameLevel.game.map.PathFinding"
local GameNotification = require "models.gameLevel.notifications.GameNotification"

---@class GameManager
GameManager            = {}

--- @param gameLevelData GameLevelData
GameManager.new        = function(gameLevelData, onVictory, onDefeat)

    local gameManager = Component.new("GameManager")

    setmetatable(gameManager, GameManager)
    GameManager.__index                  = GameManager

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local units                          = {}
    local onUnitUnderAttackEventHandlers = {}
    local onUnitDeadEventHandlers        = {}
    local onFlagCapturedEventHandlers    = {}
    local onTowerFlagEventHandlers       = {}

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local backgroundParallax             = Parallax.new("background", "assets/gameLevel/water.png", 50, "left")
    local viewPort                       = ViewPort.new(gameManager)
    local gameMap                        = GameMap.new(gameManager)
    local player                         = Player.new(gameManager)
    local mainTower1                     = MainTower.new("mainTower1", gameManager, 1)
    local mainTower2                     = MainTower.new("mainTower2", gameManager, 2)
    local fogOfWar                       = FogOfWar.new(gameManager, true)
    local pathFinding                    = PathFinding.new(gameManager)
    local gameNotifications              = GameNotification.new(gameManager)

    gameManager.addComponent(backgroundParallax)
    gameManager.addComponent(viewPort)
    gameManager.addComponent(gameMap)

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function gameManager.load()
        table.insert(units, player)
        table.insert(units, mainTower1)
        table.insert(units, mainTower2)
        -- Chargement des enemies
        for index = 1, #gameLevelData.getLevel().EnemyStarts do
            local enemyPosition = gameLevelData.getLevel().EnemyStarts[index]
            local enemy         = Enemy.new(index, enemyPosition, gameManager)
            gameManager.addComponent(enemy)
            table.insert(units, enemy)
        end
        -- Chargement des flags
        for index = 1, #gameLevelData.getLevel().Flags do
            local flagPosition = gameLevelData.getLevel().Flags[index]
            local flag         = Flag.new(gameManager, flagPosition, index)
            gameManager.addComponent(flag)
            table.insert(units, flag)
        end
        gameManager.addComponent(mainTower1)
        gameManager.addComponent(mainTower2)
        gameManager.addComponent(player)
        if FOG_OF_WAR then
            gameManager.addComponent(fogOfWar)
        end
        gameManager.addComponent(gameNotifications)
        pathFinding.load()
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

    function gameManager.getPathFinding()
        return pathFinding
    end

    ---@public
    ---@return table
    function gameManager.getUnits()
        return units
    end

    function gameManager.getMainTowerByGroup(group)
        if group == 1 then
            return mainTower1
        elseif group == 2 then
            return mainTower2
        end
    end

    function gameManager.getEnemyUnits()
        return gameManager.getFilteredUnits(function(unit) return unit.getGroup() == 2 and unit.getType() == "Tank" end)
    end

    function gameManager.getEnemyFlags()
        return gameManager.getFilteredUnits(function(unit) return unit.getGroup() == 2 and unit.getType() == "Flag" end)
    end

    function gameManager.getPlayerFlags()
        return gameManager.getFilteredUnits(function(unit) return unit.getGroup() == 1 and unit.getType() == "Flag" end)
    end

    function gameManager.getPlayerOrNeutralFlags()
        return gameManager.getFilteredUnits(function(unit) return unit.getGroup() ~= 2 and unit.getType() == "Flag" end)
    end

    function gameManager.getNeutralFlags()
        return gameManager.getFilteredUnits(function(unit) return unit.getGroup() == 0 and unit.getType() == "Flag" end)
    end

    function gameManager.getFlags()
        return gameManager.getFilteredUnits(function(unit) return unit.getType() == "Flag" end)
    end

    function gameManager.getEnemyTower()
        return mainTower2
    end

    function gameManager.getPlayerTower()
        return mainTower1
    end

    function gameManager.getFilteredUnits(filter)
        local filteredUnits = {}
        for index = 1, #units do
            if filter(units[index]) then
                table.insert(filteredUnits, units[index])
            end
        end
        return filteredUnits
    end

    function gameManager.tileContainsUnit(tileIndex, excludeUnit)
        if tileIndex == nil then return true end
        for index = 1, #units do
            local unit = units[index]
            if unit.name ~= excludeUnit.name then
                local collider = unit.getCollider()
                if collider then
                    local unitIndex = gameLevelData.getTileIndexFromRealPosition(unit.getCollider().x + gameLevelData.getLevel().TileSize / 2, unit.getCollider().y + gameLevelData.getLevel().TileSize / 2)
                    if unitIndex == tileIndex then return true end
                end
            end
        end
        return false
    end

    -- ---------------------------------------------
    -- Event Handlers Functions
    -- ---------------------------------------------
    function gameManager.onUnitTakeDamage(unit, damage, fromGroup)
        unit.takeDamage(damage, fromGroup)
        for index = 1, #onUnitUnderAttackEventHandlers do
            onUnitUnderAttackEventHandlers[index](unit, damage, fromGroup)
        end
    end

    function gameManager.onUnitDead(unit, fromGroup)
        if unit.getType() == "Flag" then
            unit.fullHealth()
            gameManager.onFlagCaptured(unit, fromGroup)
        elseif unit.getType() == "Tank" then
            unit.fullHealth()
            unit.setFrozen(unit.getGroup() == 1 and configuration:getPlayerFrozenDuration() or configuration:getEnemyFrozenDuration())
            if unit.getGroup() == 1 then
                gameManager.getViewport().resetPosition()
            else
                unit.resetPosition()
            end
        elseif unit.getType() == "MainTower" then
            unit.setCanBeDamaged(false)
            if unit.getGroup() == 1 then
                onDefeat()
            else
                onVictory()
            end
        end
        for index = 1, #onUnitDeadEventHandlers do
            onUnitDeadEventHandlers[index](unit, fromGroup)
        end
    end

    function gameManager.onFlagCaptured(unit, fromGroup)
        -- Mise a jour du proprietaire du flag
        unit.setGroup(fromGroup)
        local allFlagsCount    = #gameManager.getFlags()
        local playerFlagsCount = #gameManager.getPlayerFlags()
        local enemyFlagsCount  = #gameManager.getEnemyFlags()

        if allFlagsCount == playerFlagsCount then
            if mainTower2.isShieldActive() then
                mainTower2.setShieldOff()
                for index = 1, #onTowerFlagEventHandlers do
                    onTowerFlagEventHandlers[index](mainTower2, "off")
                end

            end
        else
            if mainTower2.isShieldActive() == false then
                mainTower2.setShieldOn()
                for index = 1, #onTowerFlagEventHandlers do
                    onTowerFlagEventHandlers[index](mainTower2, "on")
                end

            end
        end
        if allFlagsCount == enemyFlagsCount then
            if mainTower1.isShieldActive() then
                mainTower1.setShieldOff()
                for index = 1, #onTowerFlagEventHandlers do
                    onTowerFlagEventHandlers[index](mainTower1, "off")
                end
            end
        else
            if mainTower1.isShieldActive() == false then
                mainTower1.setShieldOn()
                for index = 1, #onTowerFlagEventHandlers do
                    onTowerFlagEventHandlers[index](mainTower1, "on")
                end
            end
        end

        for index = 1, #onFlagCapturedEventHandlers do
            onFlagCapturedEventHandlers[index](unit, fromGroup)
        end
    end

    function gameManager.registerOnUnitDeadEventHandler(handler)
        table.insert(onUnitDeadEventHandlers, handler)
    end

    function gameManager.registerOnFlagCapturedEventHandler(handler)
        table.insert(onFlagCapturedEventHandlers, handler)
    end

    function gameManager.registerOnUnitUnderAttackEventHandler(handler)
        table.insert(onUnitUnderAttackEventHandlers, handler)
    end

    function gameManager.registerOnTowerFlagEventHandler(handler)
        table.insert(onTowerFlagEventHandlers, handler)
    end

    return gameManager
end

return GameManager
