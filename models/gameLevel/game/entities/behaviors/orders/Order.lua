---@class Order
Order     = {}

Order.new = function()
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

    function order.clearCurrentPath()
        currentPath = nil
        pathIndex   = 1
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
