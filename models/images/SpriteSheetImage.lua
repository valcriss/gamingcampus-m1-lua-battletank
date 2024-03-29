local Component = require "models.scenes.Component"
---@class SpriteSheetImage
SpriteSheetImage = {}

---@param name string
---@param imagePath string
---@param columns number
---@param speed number
---@param loop boolean
---@param x number
---@param y number
---@param width number
---@param height number
---@param rotation number
---@param scale number
---@param color table
---@param animationEnds function
SpriteSheetImage.new = function(name, imagePath, columns, rows, speed --[[optional]], loop --[[optional]], x --[[optional]], y --[[optional]], width --[[optional]], height --[[optional]], rotation --[[optional]], scale --[[optional]], color --[[optional]], animationEnds --[[optional]])
    speed = speed or 30
    rows = rows or 1
    if loop == nil then
        loop = true
    end

    local spriteSheetImage =
        Component.new(
        name,
        {
            imagePath = imagePath,
            columns = columns,
            rows = rows,
            sourceImage = nil,
            quads = nil,
            index = 1,
            running = true,
            loop = loop,
            elapsedTime = 0,
            speed = speed / 1000,
            itemWidth = nil,
            itemHeight = nil,
            animationEnds = animationEnds
        },
        x,
        y,
        width,
        height,
        rotation,
        scale,
        color
    )

    setmetatable(spriteSheetImage, SpriteSheetImage)
    SpriteSheetImage.__index = SpriteSheetImage

    ---@public
    function spriteSheetImage.load()
        spriteSheetImage.data.sourceImage = love.graphics.newImage(imagePath)
        spriteSheetImage.data.itemWidth = math.floor(spriteSheetImage.data.sourceImage:getWidth() / spriteSheetImage.data.columns)
        spriteSheetImage.data.itemHeight = math.floor(spriteSheetImage.data.sourceImage:getHeight()/ spriteSheetImage.data.rows)
        spriteSheetImage.loadDefinition()
    end

    ---@public
    function spriteSheetImage.update(dt)
        if (spriteSheetImage.data.running == false) then
            return
        end
        spriteSheetImage.updateSpriteSheet(dt)
    end

    function spriteSheetImage.draw()
        local quad = spriteSheetImage.data.quads[spriteSheetImage.data.index]
        love.graphics.draw(spriteSheetImage.data.sourceImage, quad, screenManager:ScaleValueX(spriteSheetImage.bounds.x), screenManager:ScaleValueY(spriteSheetImage.bounds.y), math.rad(spriteSheetImage.rotation), spriteSheetImage.scale * screenManager:getScaleX(), spriteSheetImage.scale * screenManager:getScaleY(), spriteSheetImage.data.itemWidth / 2, spriteSheetImage.data.itemHeight / 2)
    end

    ---@public
    function spriteSheetImage.unload()
        spriteSheetImage.data.sourceImage:release()
        spriteSheetImage.data.sourceImage = nil
        spriteSheetImage.data.quads = nil
    end

    --[[
    Fonction qui permet de mettre a jour la frame actuellement affichée
    --]]
    ---@private
    function spriteSheetImage.updateSpriteSheet(dt)
        spriteSheetImage.data.elapsedTime = spriteSheetImage.data.elapsedTime + dt
        if (spriteSheetImage.data.elapsedTime < spriteSheetImage.data.speed) then
            return
        end

        spriteSheetImage.data.index = spriteSheetImage.data.index + 1
        spriteSheetImage.data.elapsedTime = 0
        if (spriteSheetImage.data.index < #spriteSheetImage.data.quads) then
            return
        end

        if (spriteSheetImage.data.loop == true) then
            spriteSheetImage.data.index = 1
        else
            spriteSheetImage.data.index = #spriteSheetImage.data.quads
            spriteSheetImage.data.running = false
            if (spriteSheetImage.data.animationEnds ~= nil) then
                spriteSheetImage.data.animationEnds()
            end
        end
    end

    --[[
    Fonction qui charge les quads de differents frames a partir de l'image principale
    --]]
    ---@private
    function spriteSheetImage.loadDefinition()
        spriteSheetImage.data.quads = {}
        local x = 0
        local y = 0
        for _ = 1, spriteSheetImage.data.rows do
            for _ = 1, spriteSheetImage.data.columns do
                table.insert(spriteSheetImage.data.quads, love.graphics.newQuad(x, y, spriteSheetImage.data.itemWidth, spriteSheetImage.data.itemHeight, spriteSheetImage.data.sourceImage))
                x = math.floor(x + spriteSheetImage.data.itemWidth)
            end
            y = math.floor(y + spriteSheetImage.data.itemHeight)
            x = 0
        end
        print(spriteSheetImage.name .. " found quads "..#spriteSheetImage.data.quads)
    end

    return spriteSheetImage
end

return SpriteSheetImage
