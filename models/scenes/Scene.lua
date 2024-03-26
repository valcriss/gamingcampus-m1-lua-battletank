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
        order = order
    }

    setmetatable(scene, Scene)
    Scene.__index = Scene

    function scene:load()
        Error("load() must be override")
    end

    function scene:update(dt)
    end

    function scene:draw()
    end

    function scene:unload()
        Error("unload() must be override")
    end

    return scene
end

return Scene
