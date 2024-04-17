local EasyBehavior = require "models.gameLevel.game.entities.behaviors.EasyBehavior"

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
