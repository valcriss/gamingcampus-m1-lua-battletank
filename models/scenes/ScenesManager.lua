---@class ScenesManager
ScenesManager     = {}

ScenesManager.new = function()
    local sceneManager = {
        scenes = {}
    }
    setmetatable(sceneManager, ScenesManager)
    ScenesManager.__index = ScenesManager
    ---@type boolean
    local paused          = false
    ---@public
    ---@param scene Scene
    function sceneManager:addScene(scene)
        table.insert(sceneManager.scenes, scene)
        scene.innerLoad()
        sceneManager:sortScenes()
    end

    ---@public
    ---@param scene Scene
    function sceneManager:removeScene(scene)
        local index = sceneManager:getSceneIndex(scene)
        if (index == nil) then return end
        scene.innerUnload()
        table.remove(sceneManager.scenes, index)
        sceneManager:sortScenes()
    end

    ---@private
    ---@param scene Scene
    function sceneManager:getSceneIndex(scene)
        for i, sc in ipairs(sceneManager.scenes) do
            if sc.name == scene.name then
                return i
            end
        end
        return nil
    end

    ---@private
    function sceneManager:sortScenes()
        table.sort(sceneManager.scenes, function(a, b) return a.order < b.order end)
    end

    ---@public
    function sceneManager:draw()
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i].innerDraw()
        end
    end

    ---@public
    function sceneManager:update(dt)
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i].innerUpdate(dt)
        end
    end

    function sceneManager:pause()
        paused = true
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i].pause()
        end
    end

    function sceneManager:unPause()
        paused = false
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i].unPause()
        end
    end

    function sceneManager:isPaused()
        return paused
    end

    function sceneManager:togglePause()
        paused = not paused
        if paused then
            sceneManager:pause()
        else
            sceneManager:unPause()
        end
    end

    return sceneManager
end

return ScenesManager
