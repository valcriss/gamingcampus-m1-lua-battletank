local Behavior   = require "scenes.models.gameLevel.game.entities.behaviors.Behavior"
---@class EasyBehavior
EasyBehavior     = {}

---@param gameManager GameManager
---@param enemy Enemy
EasyBehavior.new = function(gameManager, enemy)
    local easyBehavior = Behavior.new(gameManager, enemy)

    setmetatable(easyBehavior, EasyBehavior)
    EasyBehavior.__index = EasyBehavior

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local searchRange    = 7
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function easyBehavior.update(_)
        easyBehavior.updateTilesSeen(searchRange)
        local order = easyBehavior.getCurrentOrder()
        if (order ~= nil) then

        else
            -- Si le joueur est dans les parages j'attaque
            local player = easyBehavior.searchPlayerInRange(searchRange)
            if player ~= nil then
                easyBehavior.setCurrentOrder({ type = "attack", target = player })
            end
            -- Si ma tour n'a plus de bouclier je retourne en defense
            local enemyTower = gameManager.getEnemyTower()
            if enemyTower.isShieldActive() == false then
                easyBehavior.setCurrentOrder({ type = "defend", target = enemyTower })
            end
            -- Si une tours adverse est dans les parages j'attaque
            local flag = easyBehavior.searchFlagInRange(searchRange)
            if flag ~= nil then
                easyBehavior.setCurrentOrder({ type = "attack", target = flag })
            end
            -- Sinon je target la case la plus proche qui je ne connais pas et que je peux atteindre
            if easyBehavior.getCurrentPath() == nil then
                easyBehavior.setCurrentOrder({ type = "discover", target = nil })
                -- local path = gameManager.getPathFinding().findPath(enemy.getCollider().getPoint(), Vector2.new(540, 475))
                -- easyBehavior.setCurrentPath(path)
            end
        end

    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    return easyBehavior
end

return EasyBehavior
