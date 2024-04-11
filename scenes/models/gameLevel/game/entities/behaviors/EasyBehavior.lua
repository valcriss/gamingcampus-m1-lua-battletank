local Behavior   = require "scenes.models.gameLevel.game.entities.behaviors.Behavior"
local Vector2    = require "models.drawing.Vector2"
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

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function easyBehavior.update(_)
        -- Si ma tour n'a plus de bouclier je retourne en defense

        -- Si le joueur est dans les parages j'attaque

        -- Si une tours adverse est dans les parages j'attaque

        -- Sinon je target la case la plus proche qui je ne connais pas et que je peux atteindre
        if easyBehavior.getCurrentPath() == nil then
            local path = gameManager.getPathFinding().findPath(enemy.getCollider().getPoint(), Vector2.new(540, 475))
            easyBehavior.setCurrentPath(path)
        end
    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    return easyBehavior
end

return EasyBehavior
