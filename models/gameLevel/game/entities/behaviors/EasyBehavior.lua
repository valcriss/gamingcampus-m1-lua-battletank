local Behavior    = require "models.gameLevel.game.entities.behaviors.Behavior"
local MoveOrder   = require "models.gameLevel.game.entities.behaviors.orders.MoveOrder"
local AttackOrder = require "models.gameLevel.game.entities.behaviors.orders.AttackOrder"
local DefendOrder = require "models.gameLevel.game.entities.behaviors.orders.DefendOrder"

---@class EasyBehavior
EasyBehavior      = {}

---@param gameManager GameManager
---@param enemy Enemy
EasyBehavior.new  = function(gameManager, enemy)
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
    function easyBehavior.update(dt)
        if enemy.isFrozen() then
            easyBehavior.resetCurrentOrder()
            return
        end
        easyBehavior.updateTilesSeen(searchRange)
        local order = easyBehavior.getCurrentOrder()
        if (order ~= nil) then
            order.update(dt)
        else
            -- Si le joueur est dans les parages j'attaque
            local player = easyBehavior.searchPlayerInRange(searchRange)
            if player ~= nil then
                easyBehavior.setCurrentOrder(AttackOrder.new(player, gameManager, enemy, easyBehavior))
                return
            end
            -- Si ma tour n'a plus de bouclier je retourne en defense
            local enemyTower = gameManager.getEnemyTower()
            if enemyTower.isShieldActive() == false and not gameManager.getPlayer().isFrozen() then
                easyBehavior.setCurrentOrder(DefendOrder.new(enemyTower, gameManager, enemy, easyBehavior))
                return
            end
            -- Si la tour du joueur n'a plus de bouclier je fonce l'attaquer
            local playerTower = gameManager.getPlayerTower()
            if playerTower.isShieldActive() == false then
                easyBehavior.setCurrentOrder(AttackOrder.new(playerTower, gameManager, enemy, easyBehavior))
                return
            end
            -- Si une tours adverse est dans les parages j'attaque
            local flag = easyBehavior.searchFlagInRange(searchRange)
            if flag ~= nil then
                easyBehavior.setCurrentOrder(AttackOrder.new(flag, gameManager, enemy, easyBehavior))
                return
            end
            -- Sinon je target la case la plus proche qui je ne connais pas et que je peux atteindre
            local firstUnseenPosition = easyBehavior.getFirstUnSeenTilePosition()
            if firstUnseenPosition ~= nil then
                easyBehavior.setCurrentOrder(MoveOrder.new(firstUnseenPosition, gameManager, enemy, easyBehavior))
            end
        end
    end

    return easyBehavior
end

return EasyBehavior
