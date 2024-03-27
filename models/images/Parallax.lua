---@class Parallax
Parallax = {}

Parallax.new = function(assetPath, speed --[[optional]], direction --[[optional]], offsetX --[[optional]])
    direction = direction or "right"
    offsetX = offsetX or 0
    speed = speed or 10
    local parallax = {
        assetPath = assetPath,
        speed = speed,
        direction = direction,
        image = nil,
        positionX = offsetX
    }

    setmetatable(parallax, Parallax)
    Parallax.__index = Parallax

    ---@public
    function parallax:load()
        parallax.image = love.graphics.newImage(parallax.assetPath)
    end

    ---@public
    function parallax:unload()
        parallax.image:release()
        parallax.image = nil
    end

    ---@public
    function parallax:update(dt)
        local direction = 1
        if (parallax.direction == "left") then
            direction = -1
        end
        parallax.positionX = parallax.positionX + (direction * (parallax.speed * dt))
    end

    ---@public
    function parallax:draw(y --[[optional]], rotation --[[optional]], scale --[[optional]])
        y = y or 0
        rotation = rotation or 0
        scale = scale or 1
        local x = parallax.positionX - parallax.image:getWidth()
        while (x < screenManager:getWindowWidth()) do
            love.graphics.draw(parallax.image, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), math.rad(rotation), scale * screenManager:getScaleX(), scale * screenManager:getScaleY(), 0, 0)
            x = x + parallax.image:getWidth()
        end
    end

    return parallax
end

return Parallax
