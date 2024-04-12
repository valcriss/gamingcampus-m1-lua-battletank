local Behavior     = require "scenes.models.gameLevel.game.entities.behaviors.Behavior"
local MoveOrder    = require "scenes.models.gameLevel.game.entities.behaviors.orders.MoveOrder"
local AttackOrder  = require "scenes.models.gameLevel.game.entities.behaviors.orders.AttackOrder"
local DefendOrder  = require "scenes.models.gameLevel.game.entities.behaviors.orders.DefendOrder"

---@class MediumBehavior
MediumBehavior     = {}

---@param gameManager GameManager
---@param enemy Enemy
MediumBehavior.new = function(gameManager, enemy)
    local mediumBehavior = Behavior.new(gameManager, enemy)

    setmetatable(mediumBehavior, MediumBehavior)
    MediumBehavior.__index = MediumBehavior

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local searchRange      = 7
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function mediumBehavior.update(dt)
        if enemy.isFrozen() then
            mediumBehavior.resetCurrentOrder()
            return
        end
        mediumBehavior.updateTilesSeen(searchRange)
        local order = mediumBehavior.getCurrentOrder()
        if (order ~= nil) then
            order.update(dt)
        else
            -- Si le joueur est dans les parages j'attaque
            local player = mediumBehavior.searchPlayerInRange(searchRange)
            if player ~= nil then
                mediumBehavior.setCurrentOrder(AttackOrder.new(player, gameManager, enemy, mediumBehavior))
                return
            end
            -- Si ma tour n'a plus de bouclier je retourne en defense
            local enemyTower = gameManager.getEnemyTower()
            if enemyTower.isShieldActive() == false then
                mediumBehavior.setCurrentOrder(DefendOrder.new(enemyTower, gameManager, enemy, mediumBehavior))
                return
            end
            -- Si la tour du joueur n'a plus de bouclier je fonce l'attaquer
            local playerTower = gameManager.getPlayerTower()
            if playerTower.isShieldActive() == false then
                mediumBehavior.setCurrentOrder(AttackOrder.new(playerTower, gameManager, enemy, mediumBehavior))
                return
            end
            -- Si une tours adverse est dans les parages j'attaque
            local flag = mediumBehavior.searchFlagInRange(searchRange)
            if flag ~= nil then
                mediumBehavior.setCurrentOrder(AttackOrder.new(flag, gameManager, enemy, mediumBehavior))
                return
            end
            -- Sinon je target la case la plus proche qui je ne connais pas et que je peux atteindre
            local firstUnseenPosition = mediumBehavior.getFirstUnSeenTilePosition()
            if firstUnseenPosition ~= nil then
                mediumBehavior.setCurrentOrder(MoveOrder.new(firstUnseenPosition, gameManager, enemy, mediumBehavior))
            end
        end
    end

    return mediumBehavior
end

return MediumBehavior
