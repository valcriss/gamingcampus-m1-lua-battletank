---@class ScenesManager
ScenesManager = {}

ScenesManager.new = function()
    local sceneManager = {
        scenes = {}
    }
    setmetatable(sceneManager, ScenesManager)
    ScenesManager.__index = ScenesManager

    ---@param scene Scene
    function sceneManager:addScene(scene)
        table.insert(sceneManager.scenes, scene)
        scene:load()
        sceneManager:sortScenes()
    end

    ---@param scene Scene
    function sceneManager:removeScene(scene)
        local index = sceneManager:getSceneIndex(scene)
        if (index == nil) then
            print("Scene not found")
        end
        scene:unload()
        table.remove(sceneManager.scenes, index)
        sceneManager:sortScenes()
    end

    ---@param scene Scene
    function sceneManager:getSceneIndex(scene)
        for i = 1, #sceneManager.scenes do
            if sceneManager.scenes[i] == scene then
                return i
            end
        end
        return nil
    end

    function sceneManager:getScenes()
        return sceneManager.scenes
    end

    function sceneManager:sortScenes()
        table.sort(
            sceneManager.scenes,
            function(a, b)
                return a.order < b.order
            end
        )
    end

    function sceneManager:draw()
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i]:draw()
        end
    end

    function sceneManager:update(dt)
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i]:update(dt)
        end
    end

    return sceneManager
end

return ScenesManager
