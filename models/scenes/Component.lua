local Rectangle = require("models.drawing.Rectangle")
---@class Component
Component = {}

Component.new = function(name, data, x, y, width, height, rotation, scale, color)
    data = data or {}
    x = x or 0
    y = y or 0
    width = width or 0
    height = height or 0
    rotation = rotation or 0
    scale = scale or 1
    color = color or {r = 1, g = 1, b = 1, a = 1}
    local component = {
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
    function component:innerLoad()
        component:load()
        for _, subComponent in ipairs(component.components) do
            subComponent:innerLoad()
        end
    end

    ---@public
    function component:innerUpdate(dt)
        component:update(dt)
        for _, subComponent in ipairs(component.components) do
            subComponent:innerUpdate(dt)
        end
    end

    ---@public
    function component:innerDraw()
        love.graphics.setColor(component.color.r, component.color.g, component.color.b, component.color.a)
        component:draw()
        love.graphics.setColor(1, 1, 1, 1)
        for _, subComponent in ipairs(component.components) do
            subComponent:innerDraw()
        end
    end

    ---@public
    function component:innerUnload()
        for _, subComponent in ipairs(component.components) do
            subComponent:innerUnload()
        end
        component:unload()
    end

    -- Protected Functions
    ---@public
    function component:load()
    end

    ---@public
    function component:update(_)
    end

    ---@public
    function component:draw()
    end

    ---@public
    function component:unload()
    end

    -- Public Functions
    function component:addComponent(subComponent)
        table.insert(component.components, subComponent)
    end

    return component
end

return Component
