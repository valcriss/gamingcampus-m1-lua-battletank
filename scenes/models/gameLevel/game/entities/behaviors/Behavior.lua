---@class Behavior
Behavior     = {}

---@param gameManager GameManager
---@param enemy Enemy
Behavior.new = function(gameManager, enemy)
    local behavior = {}

    setmetatable(behavior, Behavior)
    Behavior.__index = Behavior

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local currentPath
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function behavior.update(dt)

    end

    -- ---------------------------------------------
    -- Protected Functions
    -- ---------------------------------------------

    function behavior.setCurrentPath(path)
        currentPath = path
    end

    function behavior.getCurrentPath()
        return currentPath
    end

    return behavior
end

return Behavior
