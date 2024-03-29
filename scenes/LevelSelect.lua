local Scene = require "models.scenes.Scene"

---@class LevelSelect
LevelSelect = {}

LevelSelect.new = function()
    order = order or 0
    local levelSelect = Scene.new("LevelSelect", 0)

    setmetatable(levelSelect, LevelSelect)
    LevelSelect.__index = LevelSelect

    -- Properties

    -- functions

    function levelSelect.load()
    end

    function levelSelect.update(dt)
    end

    function levelSelect.draw()
    end

    function levelSelect.unload()
    end

    return levelSelect
end

return LevelSelect
