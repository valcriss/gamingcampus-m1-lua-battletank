local Unit      = require "scenes.models.gameLevel.game.entities.Unit"
local Rectangle = require "models.drawing.Rectangle"
local Vector2   = require "models.drawing.Vector2"

---@class Enemy
Enemy           = {}

--- @param gameManager GameManager
Enemy.new       = function(index, enemyPosition, gameManager)
    local enemy = Unit.new("Enemy-" .. index, gameManager, "assets/gamelevel/tank-body-blue.png", "assets/gamelevel/tank-turret-blue.png", "assets/gamelevel/tank-turret-fire.png", 0, 0, 2)

    setmetatable(enemy, Enemy)
    Enemy.__index = Enemy

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    enemy.setMaxHealth(configuration:getEnemyMaxHealth())
    local enemyRealPosition
    local behavior = configuration:getEnemyBehavior(gameManager, enemy)
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function enemy.load()
        enemyRealPosition = gameManager.getGameLevelData().translateGridPositionToWorldPosition(enemyPosition.x, enemyPosition.y).offsetPosition(gameManager.getGameLevelData().data.level.TileSize / 2, gameManager.getGameLevelData().data.level.TileSize / 2)
    end

    function enemy.resetPosition()
        enemyRealPosition = gameManager.getGameLevelData().translateGridPositionToWorldPosition(enemyPosition.x, enemyPosition.y).offsetPosition(gameManager.getGameLevelData().data.level.TileSize / 2, gameManager.getGameLevelData().data.level.TileSize / 2)
    end

    function enemy.updateUnit(dt)
        local position = gameManager.getViewport().transformPointWorldToViewport(enemyRealPosition)
        enemy.setCollider(Rectangle.new(enemyRealPosition.x, enemyRealPosition.y, enemy.bounds.width, enemy.bounds.height).scale(enemy.scale).offsetPosition(-gameManager.getGameLevelData().data.level.TileSize / 2, -gameManager.getGameLevelData().data.level.TileSize / 2))
        enemy.bounds.setPoint(position.x, position.y)
        behavior.update(dt)
    end

    function enemy.lookAtPosition(position)
        enemy.setRotation(math.deg(math.atan2(position.y - enemyRealPosition.y, position.x - enemyRealPosition.x)) - 90)
    end

    function enemy.moveToPoint(destination, dt)
        local nan         = 0 / 0 -- nan
        local vector      = Vector2.new(destination.x - enemyRealPosition.x, destination.y - enemyRealPosition.y).normalize()
        local newPosition = { x = enemyRealPosition.x, y = enemyRealPosition.y }
        if vector.x == nan or vector.y == nan then
            enemy.setEnemyPosition(destination)
        else
            newPosition.x = newPosition.x + (vector.x * configuration:getEnemySpeed() * dt)
            newPosition.y = newPosition.y + (vector.y * configuration:getEnemySpeed() * dt)
            enemy.setEnemyPosition(newPosition)
        end

    end

    function enemy.getEnemyBehavior()
        return behavior
    end

    function enemy.getEnemyPosition()
        return Vector2.new(enemyRealPosition.x, enemyRealPosition.y)
    end

    function enemy.setEnemyPosition(position)
        enemyRealPosition = position
        enemy.setStartRealPosition(position)
    end

    return enemy
end

return Enemy
