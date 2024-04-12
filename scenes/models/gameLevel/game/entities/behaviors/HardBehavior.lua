local Behavior    = require "scenes.models.gameLevel.game.entities.behaviors.Behavior"
local MoveOrder   = require "scenes.models.gameLevel.game.entities.behaviors.orders.MoveOrder"
local AttackOrder = require "scenes.models.gameLevel.game.entities.behaviors.orders.AttackOrder"
local DefendOrder = require "scenes.models.gameLevel.game.entities.behaviors.orders.DefendOrder"

---@class HardBehavior
HardBehavior      = {}

---@param gameManager GameManager
---@param enemy Enemy
HardBehavior.new  = function(gameManager, enemy)
    local hardBehavior = Behavior.new(gameManager, enemy)

    setmetatable(hardBehavior, HardBehavior)
    HardBehavior.__index = HardBehavior

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local searchRange    = 7
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function hardBehavior.update(dt)
        if enemy.isFrozen() then
            hardBehavior.resetCurrentOrder()
            return
        end
        hardBehavior.updateTilesSeen(searchRange)
        local order = hardBehavior.getCurrentOrder()
        if (order ~= nil) then
            order.update(dt)
        else
            -- Si le joueur est dans les parages j'attaque
            local player = hardBehavior.searchPlayerInRange(searchRange)
            if player ~= nil then
                hardBehavior.setCurrentOrder(AttackOrder.new(player, gameManager, enemy, hardBehavior))
                return
            end
            -- Si ma tour n'a plus de bouclier je retourne en defense
            local enemyTower = gameManager.getEnemyTower()
            if enemyTower.isShieldActive() == false then
                hardBehavior.setCurrentOrder(DefendOrder.new(enemyTower, gameManager, enemy, hardBehavior))
                return
            end
            -- Si la tour du joueur n'a plus de bouclier je fonce l'attaquer
            local playerTower = gameManager.getPlayerTower()
            if playerTower.isShieldActive() == false then
                hardBehavior.setCurrentOrder(AttackOrder.new(playerTower, gameManager, enemy, hardBehavior))
                return
            end
            -- Si une tours adverse est dans les parages j'attaque
            local flag = hardBehavior.searchFlagInRange(searchRange)
            if flag ~= nil then
                hardBehavior.setCurrentOrder(AttackOrder.new(flag, gameManager, enemy, hardBehavior))
                return
            end
            -- Sinon je target la case la plus proche qui je ne connais pas et que je peux atteindre
            local firstUnseenPosition = hardBehavior.getFirstUnSeenTilePosition()
            if firstUnseenPosition ~= nil then
                hardBehavior.setCurrentOrder(MoveOrder.new(firstUnseenPosition, gameManager, enemy, hardBehavior))
            end
        end
    end

    return hardBehavior
end

return HardBehavior
