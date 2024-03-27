---@class SpriteSheetDefinition
SpriteSheetDefinition = {}

SpriteSheetDefinition.new = function(sourceImage, columns)
    local spriteSheetDefinition = {
        columns = columns,
        itemWidth = sourceImage:getWidth() / columns,
        itemHeight = sourceImage:getHeight(),
        items = {}
    }

    setmetatable(spriteSheetDefinition, SpriteSheetDefinition)
    SpriteSheetDefinition.__index = SpriteSheetDefinition

    function spriteSheetDefinition:unload()
        spriteSheetDefinition.items = nil
    end

    function spriteSheetDefinition:extractImages(sourceImage)
        local images = {}
        local x = 0
        local y = 0
        for i = 1, spriteSheetDefinition.columns do
            table.insert(images, love.graphics.newQuad(x, y, spriteSheetDefinition.itemWidth, spriteSheetDefinition.itemHeight, sourceImage))
            x = x + spriteSheetDefinition.itemWidth
        end
        return images
    end

    return spriteSheetDefinition
end

return SpriteSheetDefinition
