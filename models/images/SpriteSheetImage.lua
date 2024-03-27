--[[
Classe qui permet d'afficher une image animée à partir d'un sprite sheet
--]]
---@class SpriteSheetImage
SpriteSheetImage = {}

SpriteSheetImage.new = function(imagePath, columns, speed --[[optional]], loop --[[optional]])
    speed = speed or 30
    loop = loop or true
    local spriteSheetImage = {
        imagePath = imagePath,
        columns = columns,
        sourceImage = nil,
        quads = nil,
        index = 1,
        running = true,
        loop = loop,
        elapsedTime = 0,
        speed = speed / 1000,
        itemWidth = nil,
        itemHeight = nil
    }

    setmetatable(spriteSheetImage, SpriteSheetImage)
    SpriteSheetImage.__index = SpriteSheetImage

    ---@public
    function spriteSheetImage:load()
        spriteSheetImage.sourceImage = love.graphics.newImage(imagePath)
        spriteSheetImage.itemWidth = math.floor(spriteSheetImage.sourceImage:getWidth() / spriteSheetImage.columns)
        spriteSheetImage.itemHeight = spriteSheetImage.sourceImage:getHeight()
        spriteSheetImage:loadDefinition()
    end

    ---@public
    function spriteSheetImage:update(dt)
        if (spriteSheetImage.running == false) then
            return
        end
        spriteSheetImage:updateSpriteSheet(dt)
    end

    ---@public
    ---@param x number
    ---@param y number
    ---@param rotation number
    function spriteSheetImage:draw(x, y, rotation --[[optional]], scale --[[optional]])
        scale = scale or 1
        rotation = rotation or 0
        local quad = spriteSheetImage.quads[spriteSheetImage.index]
        love.graphics.draw(spriteSheetImage.sourceImage, quad, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), math.rad(rotation), scale * screenManager:getScaleX(), scale * screenManager:getScaleY(), spriteSheetImage.itemWidth / 2, spriteSheetImage.itemHeight / 2)
    end

    ---@public
    function spriteSheetImage:unload()
        spriteSheetImage.sourceImage:release()
        spriteSheetImage.sourceImage = nil
        spriteSheetImage.quads = nil
    end

    --[[
    Fonction qui permet de mettre a jour la frame actuellement affichée
    --]]
    ---@private
    function spriteSheetImage:updateSpriteSheet(dt)
        spriteSheetImage.elapsedTime = spriteSheetImage.elapsedTime + dt
        if (spriteSheetImage.elapsedTime < spriteSheetImage.speed) then
            return
        end

        spriteSheetImage.index = spriteSheetImage.index + 1
        spriteSheetImage.elapsedTime = 0
        if (spriteSheetImage.index < #spriteSheetImage.quads) then
            return
        end

        if (spriteSheetImage.loop == true) then
            spriteSheetImage.index = 1
        else
            spriteSheetImage.index = #spriteSheetImage.quads
            spriteSheetImage.running = false
        end
    end

    --[[
    Fonction qui charge les quads de differents frames a partir de l'image principale
    --]]
    ---@private
    function spriteSheetImage:loadDefinition()
        spriteSheetImage.quads = {}
        local x = 0
        local y = 0
        for _ = 1, spriteSheetImage.columns do
            table.insert(spriteSheetImage.quads, love.graphics.newQuad(x, y, spriteSheetImage.itemWidth, spriteSheetImage.itemHeight, spriteSheetImage.sourceImage))
            x = math.floor(x + spriteSheetImage.itemWidth)
        end
    end

    return spriteSheetImage
end

return SpriteSheetImage
