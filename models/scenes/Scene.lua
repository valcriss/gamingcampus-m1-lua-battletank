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

    ---@public
    function scene:load()
        Error("load() must be override")
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

    return scene
end

return Scene
