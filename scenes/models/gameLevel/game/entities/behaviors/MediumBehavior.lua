local EasyBehavior = require "scenes.models.gameLevel.game.entities.behaviors.EasyBehavior"
local MoveOrder    = require "scenes.models.gameLevel.game.entities.behaviors.orders.MoveOrder"
local AttackOrder  = require "scenes.models.gameLevel.game.entities.behaviors.orders.AttackOrder"
local DefendOrder  = require "scenes.models.gameLevel.game.entities.behaviors.orders.DefendOrder"

---@class MediumBehavior
MediumBehavior     = {}

---@param gameManager GameManager
---@param enemy Enemy
MediumBehavior.new = function(gameManager, enemy)
    local mediumBehavior = EasyBehavior.new(gameManager, enemy)

    setmetatable(mediumBehavior, MediumBehavior)
    MediumBehavior.__index = MediumBehavior

    return mediumBehavior
end

return MediumBehavior
