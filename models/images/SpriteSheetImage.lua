local Component      = require "models.scenes.Component"
---@class SpriteSheetImage
SpriteSheetImage     = {}

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
    columns = columns or 1
    rows    = rows or 1
    speed   = speed or 30
    if loop == nil then
        loop = true
    end

    local spriteSheetImage = Component.new(name, x, y, width, height, rotation, scale, color)

    setmetatable(spriteSheetImage, SpriteSheetImage)
    SpriteSheetImage.__index = SpriteSheetImage

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    ---@type table
    local sourceImage
    ---@type number
    local itemWidth
    ---@type number
    local itemHeight
    ---@type number
    local index              = 1
    ---@type boolean
    local running            = true
    ---@type table
    local quads              = {}
    ---@type number
    local elapsedTime        = 0

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    --- Fonction appelée automatiquement qui charge l'image depuis la ressource
    function spriteSheetImage.load()
        sourceImage                    = love.graphics.newImage(imagePath)
        itemWidth                      = math.floor(sourceImage:getWidth() / columns)
        itemHeight                     = math.floor(sourceImage:getHeight() / rows)
        spriteSheetImage.bounds.width  = itemWidth * spriteSheetImage.scale
        spriteSheetImage.bounds.height = itemHeight * spriteSheetImage.scale
        spriteSheetImage.loadDefinition()
    end

    ---@public
    --- Fonction appelée automatiquement qui met a jour l'image affichée
    function spriteSheetImage.update(dt)
        if (running == false) then
            print("animation not running")
            return
        end
        spriteSheetImage.updateSpriteSheet(dt)
    end

    ---@public
    --- Fonction appelée automatiquement qui dessine l'image
    function spriteSheetImage.draw()
        local quad = quads[index]
        love.graphics.draw(sourceImage, quad, screenManager:ScaleValueX(spriteSheetImage.bounds.x), screenManager:ScaleValueY(spriteSheetImage.bounds.y), math.rad(spriteSheetImage.rotation), spriteSheetImage.scale * screenManager:getScaleX(), spriteSheetImage.scale * screenManager:getScaleY(), itemWidth / 2, itemHeight / 2)
    end

    ---@public
    --- Fonction appelée automatiquement qui decharge l'image
    function spriteSheetImage.unload()
        sourceImage:release()
        sourceImage = nil
        quads       = nil
    end

    ---@public
    --- Fonction qui permet de déclencher l'affiche de l'image
    function spriteSheetImage.show()
        spriteSheetImage.visible = true
        running                  = true
        elapsedTime              = 0
        index                    = 1
        return spriteSheetImage
    end

    -- ---------------------------------------------
    -- Private functions
    -- ---------------------------------------------

    ---@private
    --- Fonction qui met a jour l'image affichée
    function spriteSheetImage.updateSpriteSheet(dt)
        elapsedTime = elapsedTime + dt
        if (elapsedTime < (speed / 1000)) then

            return
        end

        index       = index + 1
        elapsedTime = 0
        if (index < #quads) then
            return
        end

        if (loop == true) then
            index = 1
        else
            index   = #quads
            running = false
            if (animationEnds ~= nil) then
                animationEnds()
            end
        end
    end

    ---@private
    --- Fonction qui permet de charger la definition de l'image
    function spriteSheetImage.loadDefinition()
        quads             = {}
        local definitionX = 0
        local definitionY = 0
        for _ = 1, rows do
            for _ = 1, columns do
                table.insert(quads, love.graphics.newQuad(definitionX, definitionY, itemWidth, itemHeight, sourceImage))
                definitionX = math.floor(definitionX + itemWidth)
            end
            definitionY = math.floor(definitionY + itemHeight)
            definitionX = 0
        end
    end

    return spriteSheetImage
end

return SpriteSheetImage
