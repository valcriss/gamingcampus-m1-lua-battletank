local Behavior   = require "scenes.models.gameLevel.game.entities.behaviors.Behavior"

---@class HardBehavior
HardBehavior     = {}

---@param gameManager GameManager
---@param enemy Enemy
HardBehavior.new = function(gameManager, enemy)
    local hardBehavior = Behavior.new(gameManager, enemy)

    setmetatable(hardBehavior, HardBehavior)
    HardBehavior.__index = HardBehavior

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function hardBehavior.update(dt)

    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    return hardBehavior
end

return HardBehavior
