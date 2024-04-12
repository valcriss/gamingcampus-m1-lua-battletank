local EasyBehavior = require "scenes.models.gameLevel.game.entities.behaviors.EasyBehavior"
local MoveOrder    = require "scenes.models.gameLevel.game.entities.behaviors.orders.MoveOrder"
local AttackOrder  = require "scenes.models.gameLevel.game.entities.behaviors.orders.AttackOrder"
local DefendOrder  = require "scenes.models.gameLevel.game.entities.behaviors.orders.DefendOrder"

---@class HardBehavior
HardBehavior       = {}

---@param gameManager GameManager
---@param enemy Enemy
HardBehavior.new   = function(gameManager, enemy)
    local hardBehavior = EasyBehavior.new(gameManager, enemy)

    setmetatable(hardBehavior, HardBehavior)
    HardBehavior.__index = HardBehavior

    return hardBehavior
end

return HardBehavior
