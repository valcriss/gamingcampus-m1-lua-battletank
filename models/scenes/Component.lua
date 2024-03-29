local Rectangle = require("models.drawing.Rectangle")
---@class Component
Component = {}

---@param name string
---@param data table
---@param x number
---@param y number
---@param width number
---@param height number
---@param rotation number
---@param scale number
---@param color table
Component.new = function(name, data, x, y, width, height, rotation, scale, color)
    data = data or {}
    x = x or 0
    y = y or 0
    width = width or 0
    height = height or 0
    rotation = rotation or 0
    scale = scale or 1
    color = color or { r = 1, g = 1, b = 1, a = 1 }
    local component = {
        visible = true,
        enabled = true,
        name = name,
        data = data,
        color = color,
        rotation = rotation,
        scale = scale,
        bounds = Rectangle.new(x, y, width, height),
        components = {}
    }

    setmetatable(component, Component)
    Component.__index = Component

    -- Inner functions
    ---@public
    function component.innerLoad()
        print("Loading Component : " .. component.name)
        component.load()
        for _, subComponent in ipairs(component.components) do
            subComponent.innerLoad()
        end
    end

    ---@public
    function component.innerUpdate(dt)
        component.update(dt)
        for _, subComponent in ipairs(component.components) do
            if subComponent.enabled then
                subComponent.innerUpdate(dt)
            end
        end
    end

    ---@public
    function component.innerDraw()
        love.graphics.setColor(component.color.r, component.color.g, component.color.b, component.color.a)
        component.draw()
        love.graphics.setColor(1, 1, 1, 1)
        for _, subComponent in ipairs(component.components) do
            if subComponent.visible then
                subComponent.innerDraw()
            end
        end
    end

    ---@public
    function component.innerUnload()
        print("Unloading Component : " .. component.name)
        for _, subComponent in ipairs(component.components) do
            subComponent.innerUnload()
        end
        component.unload()
    end

    -- Protected Functions
    ---@public
    function component.load()
    end

    ---@public
    function component.update(_)
    end

    ---@public
    function component.draw()
    end

    ---@public
    function component.unload()
    end

    -- Public Functions
    ---@public
    ---@param subComponent Component
    function component.addComponent(subComponent)
        table.insert(component.components, subComponent)
    end

    function component.isVisible()
        return component.visible
    end

    function component.isEnabled()
        return component.enabled
    end

    function component.show()
        component.visible = true
        return component
    end

    function component.hide()
        component.visible = false
        return component
    end

    function component.disable()
        component.enabled = false
        return component
    end

    function component.enable()
        component.enabled = true
        return component
    end

    function component.toggleVisibility()
        if component.visible then
            component.hide()
        else
            component.show()
        end
        return component
    end

    function component.toggleEnabled()
        if component.enabled then
            component.disable()
        else
            component.enable()
        end
        return component
    end

    ---@public
    ---@param newPositionX number
    ---@param newPositionY number
    function component.setPosition(newPositionX, newPositionY)
        component.bounds.x = newPositionX
        component.bounds.y = newPositionY
    end

    ---@public
    ---@param newWidth number
    ---@param newHeight number
    function component.setSize(newWidth, newHeight)
        component.bounds.width = newWidth
        component.bounds.height = newHeight
    end

    ---@public
    ---@param newPositionX number
    ---@param newPositionY number
    ---@param newWidth number
    ---@param newHeight number
    function component.setBounds(newPositionX, newPositionY, newWidth, newHeight)
        component.bounds.x = newPositionX
        component.bounds.y = newPositionY
        component.bounds.width = newWidth
        component.bounds.height = newHeight
    end

    return component
end

return Component
