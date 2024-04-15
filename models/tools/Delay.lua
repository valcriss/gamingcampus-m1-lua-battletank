local Component = require "models.scenes.Component"

---@class Delay
Delay           = {}

---@param name string
Delay.new       = function(name)
    local delay = Component.new(name)

    setmetatable(delay, Delay)
    Delay.__index     = Delay

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local action
    local duration    = 0
    local elapsedTime = 0

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    --- Fonction appelée automatiquement qui va lancer l'action apres une durée définie
    function delay.update(dt)
        if (action == nil) then
            return
        end
        elapsedTime = elapsedTime + dt
        if (elapsedTime >= duration) then
            action()
            action      = nil
            elapsedTime = 0
            duration    = 0
        end
    end

    ---@public
    --- Permet de définir une action qui sera executé apres une durée définie
    ---@param waitDuration number
    ---@param completedAction function
    function delay.setDelay(waitDuration, completedAction)
        duration    = waitDuration
        action      = completedAction
        elapsedTime = 0
        return delay
    end

    return delay
end

return Delay
