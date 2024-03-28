local Component = require "models.scenes.Component"
---@class Parallax
Parallax = {}

---@param name string
---@param assetPath string
---@param speed number
---@param direction string
---@param offsetX number
---@param y number
---@param rotation number
---@param scale number
Parallax.new = function(name, assetPath, speed --[[optional]], direction --[[optional]], offsetX --[[optional]], y --[[optional]], rotation --[[optional]], scale --[[optional]])
    direction = direction or "right"
    offsetX = offsetX or 0
    speed = speed or 10
    local parallax = Component.new(name, {
        assetPath = assetPath,
        speed = speed,
        direction = direction,
        image = nil,
        positionX = offsetX
    },
            nil,
            y,
            nil,
            nil,
            rotation,
            scale
    )

    setmetatable(parallax, Parallax)
    Parallax.__index = Parallax

    ---@public
    function parallax.load()
        parallax.data.image = love.graphics.newImage(parallax.data.assetPath)
    end

    ---@public
    function parallax.unload()
        parallax.data.image:release()
        parallax.data.image = nil
    end

    ---@public
    function parallax.update(dt)
        local dir = 1
        if (parallax.data.direction == "left") then
            dir = -1
        end
        parallax.data.positionX = parallax.data.positionX + (dir * (parallax.data.speed * dt))
    end

    ---@public
    function parallax.draw()
        local x = parallax.data.positionX - parallax.data.image:getWidth()
        while (x < screenManager:getWindowWidth()) do
            love.graphics.draw(parallax.data.image, screenManager:ScaleValueX(x), screenManager:ScaleValueY(parallax.bounds.y), math.rad(parallax.rotation), parallax.scale * screenManager:getScaleX(), parallax.scale * screenManager:getScaleY(), 0, 0)
            x = x + parallax.data.image:getWidth()
        end
    end

    return parallax
end

return Parallax
