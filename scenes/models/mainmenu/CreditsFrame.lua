local BitmapText = require "models.texts.BitmapText"
local MenuFrame  = require "models.ui.MenuFrame"
---@class CreditsFrame
CreditsFrame     = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
CreditsFrame.new = function(name, title, x, y, width, height, moveSpeed)
    local creditsFrame = MenuFrame.new(
            name,
            title,
            x,
            y,
            width,
            height,
            moveSpeed,
            "assets/ui/yellow_panel.png"
    )

    setmetatable(creditsFrame, CreditsFrame)
    CreditsFrame.__index    = CreditsFrame

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    local graphicAssetsList = "- Tanks by kenney (https://kenney.nl/)\n- UI Pack by kenney (https://kenney.nl/)\n- Top-down Tanks Redux by kenney (https://kenney.nl/)\n- Map Pack by kenney (https://kenney.nl/)"
    local fontAssetsList    = "- Bouncy by Mans Greback (https://www.mansgreback.com/)\n- Hey Comic by Khurasan (https://www.dafont.com/fr/hey-comic.font)\n- Komika Axis by Vigilante Typeface Corporation (https://www.dafont.com/fr/komika-axis.font)\n- Roboto by Google Android Design (https://m3.material.io/styles/typography/overview)"
    local soundAssetsList   = "- Game music – retro, arcade melody with electro drums and synth elements by zapsplat (https://www.zapsplat.com/)\n- Digital retro arcade game tone, ascending blips 1 by zapsplat (https://www.zapsplat.com/)\n- Boing effect by pixabay (https://pixabay.com/users/pixabay-1/)\n- Wrong effect by pixabay (https://pixabay.com/users/pixabay-1/)\n- Movement Swipe Whoosh 3 by floraphonic (https://pixabay.com/users/floraphonic-38928062/)\n- Button pressed effect in ui-pack by kenney (https://kenney.nl/)"
    local devAssetsList     = "- json.lua by rxi (https://github.com/rxi/json.lua)\n- Spriter Pro by brashmonkey (https://brashmonkey.com/spriter-pro/)\n- GIMP (https://www.gimp.org/)"

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------

    local graphicAssetsFont = BitmapText.new(creditsFrame.name .. "_graphicAssetsFont", "assets/fonts/roboto-bold-black.fnt", "Graphics Assets")
    local fontsAssetsFont   = BitmapText.new(creditsFrame.name .. "_fontsAssetsFont", "assets/fonts/roboto-bold-black.fnt", "Fonts Assets")
    local soundAssetsFont   = BitmapText.new(creditsFrame.name .. "_soundAssetsFont", "assets/fonts/roboto-bold-black.fnt", "Sound Assets")
    local devAssetsFont     = BitmapText.new(creditsFrame.name .. "_soundAssetsFont", "assets/fonts/roboto-bold-black.fnt", "Development Libraries")
    local graphicAssets     = BitmapText.new(creditsFrame.name .. "_graphicAssetsList", "assets/fonts/roboto-regular-black.fnt", graphicAssetsList)
    local fontAssets        = BitmapText.new(creditsFrame.name .. "_fontAssetsList", "assets/fonts/roboto-regular-black.fnt", fontAssetsList)
    local soundAssets       = BitmapText.new(creditsFrame.name .. "_soundAssetsList", "assets/fonts/roboto-regular-black.fnt", soundAssetsList)
    local devAssets         = BitmapText.new(creditsFrame.name .. "_soundAssetsList", "assets/fonts/roboto-regular-black.fnt", devAssetsList)

    creditsFrame.addComponent(graphicAssetsFont)
    creditsFrame.addComponent(fontsAssetsFont)
    creditsFrame.addComponent(soundAssetsFont)
    creditsFrame.addComponent(devAssetsFont)
    creditsFrame.addComponent(graphicAssets)
    creditsFrame.addComponent(fontAssets)
    creditsFrame.addComponent(soundAssets)
    creditsFrame.addComponent(devAssets)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    ---@param dt number
    function creditsFrame.update(dt)
        creditsFrame.updateAnimation(dt)

        local paddingY    = 20
        local graphicsTop = paddingY
        local fontsTop    = graphicsTop + graphicAssetsFont.getHeight() + graphicAssets.getHeight() + paddingY
        local soundTop    = fontsTop + fontsAssetsFont.getHeight() + fontAssets.getHeight() + paddingY
        local devTop      = soundTop + soundAssetsFont.getHeight() + soundAssets.getHeight() + paddingY

        graphicAssetsFont.setPosition(creditsFrame.bounds.x + creditsFrame.getOffsetX() + 20, creditsFrame.bounds.y + graphicsTop)
        graphicAssets.setPosition(creditsFrame.bounds.x + creditsFrame.getOffsetX() + 35, creditsFrame.bounds.y + graphicsTop + paddingY)
        fontsAssetsFont.setPosition(creditsFrame.bounds.x + creditsFrame.getOffsetX() + 20, creditsFrame.bounds.y + fontsTop)
        fontAssets.setPosition(creditsFrame.bounds.x + creditsFrame.getOffsetX() + 35, creditsFrame.bounds.y + fontsTop + paddingY)
        soundAssetsFont.setPosition(creditsFrame.bounds.x + creditsFrame.getOffsetX() + 20, creditsFrame.bounds.y + soundTop)
        soundAssets.setPosition(creditsFrame.bounds.x + creditsFrame.getOffsetX() + 35, creditsFrame.bounds.y + soundTop + paddingY)
        devAssetsFont.setPosition(creditsFrame.bounds.x + creditsFrame.getOffsetX() + 20, creditsFrame.bounds.y + devTop)
        devAssets.setPosition(creditsFrame.bounds.x + creditsFrame.getOffsetX() + 35, creditsFrame.bounds.y + devTop + paddingY)
        creditsFrame.bounds.height = devTop + devAssetsFont.getHeight() + devAssets.getHeight() + paddingY
    end

    return creditsFrame
end

return CreditsFrame
