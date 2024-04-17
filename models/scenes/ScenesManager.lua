---@class ScenesManager
local ScenesManager = {}

ScenesManager.new   = function()
    local sceneManager = {
        scenes = {}
    }
    setmetatable(sceneManager, ScenesManager)
    ScenesManager.__index = ScenesManager

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    ---@type boolean
    local paused          = false

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    --- Ajoute une scene au ScenesManager
    ---@param scene Scene
    function sceneManager:addScene(scene)
        table.insert(sceneManager.scenes, scene)
        scene.innerLoad()
        sceneManager:sortScenes()
    end

    ---@public
    --- Retire une scene du ScenesManager
    ---@param scene Scene
    function sceneManager:removeScene(scene)
        local index = sceneManager:getSceneIndex(scene)
        if (index == nil) then return end
        scene.innerUnload()
        table.remove(sceneManager.scenes, index)
        sceneManager:sortScenes()
    end

    ---@public
    --- Fonction qui dessine les scenes actuellement chargées
    function sceneManager:draw()
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i].innerDraw()
        end
    end

    ---@public
    --- Fonction qui met à jour les scenes actuellement chargées
    function sceneManager:update(dt)
        dt = math.min(dt, 1 / 25)
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i].innerUpdate(dt)
        end
    end

    ---@public
    --- Fonction qui met en pause les scenes actuellement chargées
    function sceneManager:pause()
        paused = true
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i].pause()
        end
    end

    ---@public
    --- Fonction qui retire la pause les scenes actuellement chargées
    function sceneManager:unPause()
        paused = false
        for i = 1, #sceneManager.scenes do
            sceneManager.scenes[i].unPause()
        end
    end

    ---@public
    --- Fonction qui permet de savoir si le ScenesManager est en pause
    ---@return boolean
    function sceneManager:isPaused()
        return paused
    end

    ---@public
    --- Fonction qui permet de basculer entre pause et unpause
    function sceneManager:togglePause()
        paused = not paused
        if paused then
            sceneManager:pause()
        else
            sceneManager:unPause()
        end
    end

    -- ---------------------------------------------
    -- Private functions
    -- ---------------------------------------------
    ---@private
    --- Retourne l'index d'une scene
    ---@param scene Scene
    ---@return number
    function sceneManager:getSceneIndex(scene)
        for i, sc in ipairs(sceneManager.scenes) do
            if sc.name == scene.name then
                return i
            end
        end
        return nil
    end

    ---@private
    --- Tri les scenes par leur parametre order
    function sceneManager:sortScenes()
        table.sort(sceneManager.scenes, function(a, b) return a.order < b.order end)
    end

    return sceneManager
end

return ScenesManager
