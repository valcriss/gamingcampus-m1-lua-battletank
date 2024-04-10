local Behavior     = require "scenes.models.gameLevel.game.entities.behaviors.Behavior"

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

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function mediumBehavior.update(dt)

    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    return mediumBehavior
end

return MediumBehavior
