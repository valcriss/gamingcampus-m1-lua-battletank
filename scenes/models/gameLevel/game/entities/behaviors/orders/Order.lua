---@class Order
Order     = {}

---@param gameManager GameManager
---@param enemy Enemy
Order.new = function(type, target, gameManager, enemy, behavior)
    local order = {}

    setmetatable(order, Order)
    Order.__index   = Order

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local currentPath
    local pathIndex = 1
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function order.update(_)

    end

    function order.setCurrentPath(path)
        currentPath = path
        pathIndex   = 1
    end

    function order.getPathNode()
        if pathIndex > #currentPath then
            return nil
        end
        return currentPath[pathIndex]
    end

    function order.nextNode()
        pathIndex = pathIndex + 1
    end

    function order.getCurrentPath()
        return currentPath
    end

    return order
end

return Order
