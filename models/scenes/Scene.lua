local Component = require "models.scenes.Component"
---@class Scene
local Scene = {}

---@param name string
---@param order number
---@param backgroundColor table
Scene.new = function(name, order --[[optional]], backgroundColor --[[optional]])
    order = order or 0
    backgroundColor = backgroundColor or {r = 0, g = 0, b = 0}
    scene = {
        ---@type string
        name = name,
        ---@type number
        order = order,
        ---@type table
        backgroundColor = backgroundColor,
        ---@type Component[]
        components = {}
    }

    setmetatable(scene, Scene)
    Scene.__index = Scene

    -- Inner functions
    ---@public
    function scene.innerLoad()
        print("Loading scene : " .. scene.name)
        scene.load()
        for _, subComponent in ipairs(scene.components) do
            subComponent.innerLoad()
        end
    end

    ---@public
    function scene.innerUpdate(dt)
        scene.update(dt)
        for _, subComponent in ipairs(scene.components) do
            if subComponent.enabled then
                subComponent.innerUpdate(dt)
            end
        end
    end

    ---@public
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
    function scene.innerUnload()
        print("Unloading scene : " .. scene.name)
        for _, subComponent in ipairs(scene.components) do
            subComponent.innerUnload()
        end
        scene.unload()
    end

    -- Protected Functions
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

    -- Public Functions
    ---@public
    ---@param component Component
    ---@return Scene
    function scene.addComponent(component)
        table.insert(scene.components, component)
        return scene
    end

    function scene.switchToScene(oldScene, newScene)
        scenesManager:removeScene(oldScene)
        scenesManager:addScene(newScene)
    end

    return scene
end

return Scene
