local Component = require "models.scenes.Component"
---@class Scene
local Scene = {}

---@param name string
---@param order number
Scene.new = function(name, order --[[optional]])
    order = order or 0

    scene = {
        ---@type string
        name = name,
        ---@type number
        order = order,
        ---@type Component[]
        components = {}
    }

    setmetatable(scene, Scene)
    Scene.__index = Scene

    -- Inner functions
    ---@public
    function scene:innerLoad()
        print("Scene:innerLoad()")
        scene:load()
        print("Scene sub components: " .. #scene.components)
        for _, subComponent in ipairs(scene.components) do
            subComponent:innerLoad()
        end
    end

    ---@public
    function scene:innerUpdate(dt)
        scene:update(dt)
        for _, subComponent in ipairs(scene.components) do
            subComponent:innerUpdate(dt)
        end
    end

    ---@public
    function scene:innerDraw()
        scene:draw()
        for _, subComponent in ipairs(scene.components) do
            subComponent:innerDraw()
        end
    end

    ---@public
    function scene:innerUnload()
        for _, subComponent in ipairs(scene.components) do
            subComponent:innerUnload()
        end
        scene:unload()
    end

    -- Protected Functions
    ---@public
    function scene:load()
        print("No load function implemented")
    end

    ---@public
    function scene:update(_)
    end

    ---@public
    function scene:draw()
    end

    ---@public
    function scene:unload()
    end

    -- Public Functions
    function scene:addComponent(component)
        table.insert(scene.components, component)
    end

    return scene
end

return Scene
