local Component = require "models.scenes.Component"
---@class Parallax
Parallax        = {}

---@param name string
---@param assetPath string
---@param speed number
---@param direction string
---@param offsetX number
---@param y number
---@param rotation number
---@param scale number
Parallax.new    = function(name, assetPath, speed --[[optional]], direction --[[optional]], offsetX --[[optional]], y --[[optional]], rotation --[[optional]], scale --[[optional]])
    direction      = direction or "left"
    offsetX        = offsetX or 0
    speed          = speed or 10

    local parallax = Component.new(name, 0, y, nil, nil, rotation, scale)

    setmetatable(parallax, Parallax)
    Parallax.__index = Parallax

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    local parallaxImage
    local positionX  = 0

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    --- Fonction appelée automatiquement qui charge l'image depuis la ressource
    function parallax.load()
        parallaxImage = love.graphics.newImage(assetPath)
    end

    ---@public
    --- Fonction appelée automatiquement qui decharge l'image
    function parallax.unload()
        parallaxImage:release()
        parallaxImage = nil
    end

    ---@public
    --- Fonction appelée automatiquement qui met a jour l'image affichée
    function parallax.update(dt)
        local dir = 1
        if (direction == "left") then
            dir = -1
        end
        positionX = positionX + (dir * (speed * dt))
    end

    ---@public
    --- Fonction appelée automatiquement qui dessine l'image
    function parallax.draw()
        local x = positionX - parallaxImage:getWidth()
        while (x < screenManager:getWindowWidth()) do
            love.graphics.draw(parallaxImage, screenManager:ScaleValueX(x), screenManager:ScaleValueY(parallax.bounds.y), math.rad(parallax.rotation), parallax.scale * screenManager:getScaleX(), parallax.scale * screenManager:getScaleY(), 0, 0)
            x = x + parallaxImage:getWidth()
        end
    end

    return parallax
end

return Parallax
