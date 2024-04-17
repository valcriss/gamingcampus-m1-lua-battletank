---@class Scene
local Scene = {}

---@param name string
---@param order number
---@param backgroundColor table
Scene.new   = function(name, order --[[optional]], backgroundColor --[[optional]])
    order           = order or 0
    backgroundColor = backgroundColor or { r = 0, g = 0, b = 0 }
    local scene     = {
        ---@type string
        name            = name,
        ---@type number
        order           = order,
        ---@type table
        backgroundColor = backgroundColor,
        ---@type Component[]
        components      = {}
    }

    setmetatable(scene, Scene)
    Scene.__index = Scene

    -- ---------------------------------------------
    -- ScenesManager functions
    -- ---------------------------------------------
    ---@public
    --- Fonction appelée par le scenesManager qui va charger la scene et ses composants
    function scene.innerLoad()
        scene.load()
        for _, subComponent in ipairs(scene.components) do
            subComponent.innerLoad()
        end
    end

    ---@public
    --- Fonction appelée par le scenesManager qui va mettre à jour la scene et ses composants
    function scene.innerUpdate(dt)
        scene.update(dt)
        for _, subComponent in ipairs(scene.components) do
            if subComponent.enabled and subComponent.visible then
                subComponent.innerUpdate(dt)
            end
        end
    end

    ---@public
    --- Fonction appelée par le scenesManager qui va dessiner la scene et ses composants
    function scene.innerDraw()
        screenManager:clear(scene.backgroundColor.r, scene.backgroundColor.g, scene.backgroundColor.b)
        scene.draw()
        for _, subComponent in ipairs(scene.components) do
            if subComponent.visible then
                subComponent.innerDraw()
            end
        end
    end

    ---@public
    --- Fonction appelée par le scenesManager qui va decharger la scene et ses composants
    function scene.innerUnload()
        for _, subComponent in ipairs(scene.components) do
            subComponent.innerUnload()
        end
        scene.unload()
    end

    -- ---------------------------------------------
    -- Protected functions
    -- ---------------------------------------------
    ---@public
    function scene.load()
    end

    ---@public
    function scene.update(_)
    end

    ---@public
    function scene.draw()
    end

    ---@public
    function scene.unload()
    end

    ---@public
    function scene.pause()
    end

    ---@public
    function scene.unPause()
    end

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    --- Ajoute un composant a la scene
    ---@param component Component
    ---@return Scene
    function scene.addComponent(component)
        table.insert(scene.components, component)
        return scene
    end

    ---@public
    --- Change la scene
    ---@param oldScene Scene
    ---@param newScene Scene
    function scene.switchToScene(oldScene, newScene)
        scenesManager:removeScene(oldScene)
        scenesManager:addScene(newScene)
    end

    return scene
end

return Scene
