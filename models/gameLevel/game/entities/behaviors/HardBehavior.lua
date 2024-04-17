local EasyBehavior = require "models.gameLevel.game.entities.behaviors.EasyBehavior"

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
