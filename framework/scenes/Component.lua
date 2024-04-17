local Rectangle = require("framework.drawing.Rectangle")
---@class Component
Component       = {}

---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@param rotation number
---@param scale number
---@param color table
Component.new   = function(name, x, y, width, height, rotation, scale, color)
    x               = x or 0
    y               = y or 0
    width           = width or 0
    height          = height or 0
    rotation        = rotation or 0
    scale           = scale or 1
    color           = color or { r = 1, g = 1, b = 1, a = 1 }
    local component = {
        visible    = true,
        enabled    = true,
        name       = name,
        color      = color,
        rotation   = rotation,
        scale      = scale,
        bounds     = Rectangle.new(x, y, width, height),
        components = {}
    }

    setmetatable(component, Component)
    Component.__index = Component

    -- ---------------------------------------------
    -- Scenes functions
    -- ---------------------------------------------
    ---@public
    --- Fonction appelée par la scene parente qui va charger le composant et ses sous composants
    function component.innerLoad()
        component.load()
        for _, subComponent in ipairs(component.components) do
            subComponent.innerLoad()
        end
    end

    ---@public
    --- Fonction appelée par la scene parente qui va mettre à jour le composant et ses sous composants
    function component.innerUpdate(dt)
        component.update(dt)
        for _, subComponent in ipairs(component.components) do
            if subComponent.enabled and subComponent.visible then
                subComponent.innerUpdate(dt)
            end
        end
    end

    ---@public
    --- Fonction appelée par la scene parente qui va dessiner le composant et ses sous composants
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
    --- Fonction appelée par la scene parente qui va decharger le composant et ses sous composants
    function component.innerUnload()
        for _, subComponent in ipairs(component.components) do
            subComponent.innerUnload()
        end
        component.unload()
    end

    -- ---------------------------------------------
    -- Protected functions
    -- ---------------------------------------------
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

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    --- Ajoute un sous composant au composant
    ---@param subComponent Component
    function component.addComponent(subComponent)
        table.insert(component.components, subComponent)
    end

    ---@public
    --- Retourne la visibilité du composant
    ---@return boolean
    function component.isVisible()
        return component.visible
    end

    ---@public
    --- Retourne l'activation du composant
    ---@return boolean
    function component.isEnabled()
        return component.enabled
    end

    ---@public
    --- Affiche le composant
    ---@return Component
    function component.show()
        component.visible = true
        return component
    end

    ---@public
    --- Cache le composant
    ---@return Component
    function component.hide()
        component.visible = false
        return component
    end

    ---@public
    --- Desactive le composant
    ---@return Component
    function component.disable()
        component.enabled = false
        return component
    end

    ---@public
    --- Active le composant
    ---@return Component
    function component.enable()
        component.enabled = true
        return component
    end

    ---@public
    --- Permet de définir la position du composant
    ---@param newPositionX number
    ---@param newPositionY number
    function component.setPosition(newPositionX, newPositionY)
        component.bounds.x = newPositionX
        component.bounds.y = newPositionY
    end

    ---@public
    --- Permet de définir la taille du composant
    ---@param newWidth number
    ---@param newHeight number
    function component.setSize(newWidth, newHeight)
        component.bounds.width  = newWidth
        component.bounds.height = newHeight
    end

    ---@public
    --- Permet de définir la position et la taille du composant
    ---@param newPositionX number
    ---@param newPositionY number
    ---@param newWidth number
    ---@param newHeight number
    function component.setBounds(newPositionX, newPositionY, newWidth, newHeight)
        component.bounds.x      = newPositionX
        component.bounds.y      = newPositionY
        component.bounds.width  = newWidth
        component.bounds.height = newHeight
    end

    ---@public
    --- Permet de définir la rotation du composant
    ---@param newRotation number
    function component.setRotation(newRotation)
        component.rotation = newRotation
    end

    return component
end

return Component
