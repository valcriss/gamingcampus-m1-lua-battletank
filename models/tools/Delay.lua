---@class Delay
Delay     = {}

Delay.new = function(name)
    local delay = Component.new(
            name,
            {
                action      = nil,
                delay       = 0,
                elapsedTime = 0
            }
    )

    setmetatable(delay, Delay)
    Delay.__index = Delay

    ---@public
    function delay.update(dt)
        if (delay.data.action == nil) then
            return
        end
        delay.data.elapsedTime = delay.data.elapsedTime + dt
        if (delay.data.elapsedTime >= delay.data.delay) then
            delay.data.action()
            delay.data.action      = nil
            delay.data.elapsedTime = 0
            delay.data.delay       = 0
        end
    end

    ---@public
    ---@param duration number
    ---@param action function
    function delay.setDelay(duration, action)
        delay.data.delay       = duration
        delay.data.action      = action
        delay.data.elapsedTime = 0
    end

    return delay
end

return Delay
