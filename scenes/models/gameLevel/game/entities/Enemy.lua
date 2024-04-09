local Unit      = require "scenes.models.gameLevel.game.entities.Unit"
local Rectangle = require "models.drawing.Rectangle"

---@class Enemy
Enemy           = {}

--- @param gameManager GameManager
Enemy.new       = function( enemyPosition, gameManager)
    local enemy = Unit.new("Enemy", gameManager, "assets/gamelevel/tank-body-blue.png", "assets/gamelevel/tank-turret-blue.png", "assets/gamelevel/tank-turret-fire.png", 0, 0, 2)

    setmetatable(enemy, Enemy)
    Enemy.__index    = Enemy

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local enemyRealPosition
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function enemy.load()
        enemyRealPosition = gameManager.getGameLevelData().translateGridPositionToWorldPosition(enemyPosition.x, enemyPosition.y).offsetPosition(gameManager.getGameLevelData().data.level.TileSize / 2, gameManager.getGameLevelData().data.level.TileSize / 2)
    end

    function enemy.updateUnit(_)
        local position = gameManager.getViewport().transformPointWorldToViewport(enemyRealPosition)
        enemy.setCollider(Rectangle.new(enemyRealPosition.x, enemyRealPosition.y, enemy.bounds.width, enemy.bounds.height).scale(enemy.scale).offsetPosition(-gameManager.getGameLevelData().data.level.TileSize / 2, -gameManager.getGameLevelData().data.level.TileSize / 2))
        enemy.bounds.setPoint(position.x, position.y)
    end

    return enemy
end

return Enemy
