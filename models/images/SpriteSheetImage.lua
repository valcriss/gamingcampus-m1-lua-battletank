local SpriteSheetDefinition = require("models.images.SpriteSheetDefinition")
local JsonAsset = require("models.tools.JsonAsset")
local Trace = require "models.tools.Trace"
---@class SpriteSheetImage
SpriteSheetImage = {}

SpriteSheetImage.new = function(imagePath, columns, speed --[[optional]], loop --[[optional]])
    speed = speed or 30
    loop = loop or true
    local spriteSheetImage = {
        imagePath = imagePath,
        columns = columns,
        definition = nil,
        sourceImage = nil,
        images = nil,
        index = 1,
        running = true,
        loop = loop,
        elapsedTime = 0,
        speed = speed / 1000
    }

    setmetatable(spriteSheetImage, SpriteSheetImage)
    SpriteSheetImage.__index = SpriteSheetImage

    -- Classe Properties

    -- Classe functions
    ---@public
    function spriteSheetImage:load()
        spriteSheetImage.sourceImage = love.graphics.newImage(imagePath)
        spriteSheetImage:loadDefinition()
    end

    function spriteSheetImage:update(dt)
        if (spriteSheetImage.running == false) then
            return
        end
        spriteSheetImage.elapsedTime = spriteSheetImage.elapsedTime + dt
        if (spriteSheetImage.elapsedTime > spriteSheetImage.speed) then
            spriteSheetImage.index = spriteSheetImage.index + 1
            spriteSheetImage.elapsedTime = 0
            if (spriteSheetImage.index > #spriteSheetImage.images) then
                if (spriteSheetImage.loop == true) then
                    spriteSheetImage.index = 1
                else
                    spriteSheetImage.index = #spriteSheetImage.images
                    spriteSheetImage.running = false
                end
            end
        end
    end

    ---@public
    ---@param x number
    ---@param y number
    ---@param rotation number
    function spriteSheetImage:draw(x, y, rotation --[[optional]], scale)
        scale = scale or 1
        rotation = rotation or 0
        local quad = spriteSheetImage.images[spriteSheetImage.index]
        sw = spriteSheetImage.definition.itemWidth
        sh = spriteSheetImage.definition.itemHeight

        love.graphics.draw(spriteSheetImage.sourceImage, quad, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), math.rad(rotation), scale * screenManager:getScaleX(), scale * screenManager:getScaleY(), sw / 2, sh / 2)
    end

    ---@public
    function spriteSheetImage:unload()
        spriteSheetImage.definition:unload()
        spriteSheetImage.definition = nil
        spriteSheetImage.sourceImage:release()
        spriteSheetImage.sourceImage = nil
        spriteSheetImage.images = nil
    end

    ---@private
    function spriteSheetImage:loadDefinition()
        spriteSheetImage.definition = SpriteSheetDefinition.new(spriteSheetImage.sourceImage, spriteSheetImage.columns)
        spriteSheetImage.images = spriteSheetImage.definition:extractImages(spriteSheetImage.sourceImage)
    end

    return spriteSheetImage
end

return SpriteSheetImage
