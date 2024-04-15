---@class MapTankMovement
MapTankMovement     = {}

MapTankMovement.new = function(level)
    local mapTankMovement = {
        ---@type number
        level                  = level,
        ---@type table
        currentPath            = nil,
        ---@type number
        currentPathIndex       = nil,
        ---@type number
        currentPathElapsedTime = 0,
        ---@type function
        onPathCompleted        = nil,
        ---@type table
        initialPosition        = {
            -- Initial position for level 1
            { x = 3, y = 9, r = 0 },
            -- Initial position for level 2
            { x = 4, y = 9, r = -90 },
            -- Initial position for level 3
            { x = 11, y = 6, r = 0 }
        },
        ---@type table
        paths                  = {
            -- Path to level 1
            { path = { { x = 3, y = 9, r = 0 }, { x = 4, y = 9, r = 0 } }, stepDuration = 1 },
            -- Path to level 2
            { path          = {
                { x = 4, y = 9, r = -90 },
                { x = 4, y = 8, r = -90 },
                { x = 4, y = 8, r = 0 },
                { x = 5, y = 8, r = 0 },
                { x = 6, y = 8, r = 0 },
                { x = 7, y = 8, r = 0 },
                { x = 8, y = 8, r = 0 },
                { x = 8, y = 8, r = -90 },
                { x = 8, y = 7, r = -90 },
                { x = 8, y = 7, r = 0 },
                { x = 9, y = 7, r = 0 },
                { x = 10, y = 7, r = 0 },
                { x = 10, y = 7, r = -90 },
                { x = 10, y = 6, r = -90 },
                { x = 10, y = 6, r = 0 },
                { x = 11, y = 6, r = 0 },
            }, stepDuration = 0.25 },
            -- Path to level 3
            { path          = {
                { x = 11, y = 6, r = 0 },
                { x = 12, y = 6, r = 0 },
                { x = 13, y = 6, r = 0 },
                { x = 14, y = 6, r = 0 },
                { x = 14, y = 6, r = -90 },
                { x = 14, y = 5, r = -90 },
                { x = 14, y = 4, r = -90 },
                { x = 14, y = 4, r = 0 },
                { x = 15, y = 4, r = 0 },
                { x = 16, y = 4, r = 0 },
                { x = 16, y = 4, r = -90 },
                { x = 16, y = 3, r = -90 },
                { x = 16, y = 3, r = 0 },
                { x = 17, y = 3, r = 0 },
                { x = 18, y = 3, r = 0 },
            }, stepDuration = 0.25 },
        }
    }

    setmetatable(mapTankMovement, MapTankMovement)
    MapTankMovement.__index = MapTankMovement

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    ---@param levelPath string
    ---@param onPathCompleted function
    function mapTankMovement.runPath(levelPath, onPathCompleted)
        mapTankMovement.onPathCompleted = onPathCompleted
        mapTankMovement.currentPath     = mapTankMovement.paths[levelPath]
        mapTankMovement.startPathStep(1)
    end

    ---@public
    ---@param index number
    function mapTankMovement.startPathStep(index)
        mapTankMovement.currentPathIndex       = index
        mapTankMovement.currentPathElapsedTime = 0
        if (index + 1 > #mapTankMovement.currentPath.path) then
            mapTankMovement.currentPath = nil
            if (mapTankMovement.onPathCompleted ~= nil) then
                mapTankMovement.onPathCompleted()
            end
        end
    end

    ---@public
    function mapTankMovement.update(dt)
        if (mapTankMovement.currentPath == nil) then
            return nil
        end
        mapTankMovement.currentPathElapsedTime = mapTankMovement.currentPathElapsedTime + dt
        local currentStepStart                 = mapTankMovement.currentPath.path[mapTankMovement.currentPathIndex]
        local currentStepEnd                   = mapTankMovement.currentPath.path[mapTankMovement.currentPathIndex + 1]
        local currentStepStartRealPosition     = mapTankMovement.getRealPosition(currentStepStart.x, currentStepStart.y, currentStepStart.r)
        local currentStepEndRealPosition       = mapTankMovement.getRealPosition(currentStepEnd.x, currentStepEnd.y, currentStepEnd.r)
        local ratio                            = math.min(1, mapTankMovement.currentPathElapsedTime / mapTankMovement.currentPath.stepDuration)
        local x                                = mapTankMovement.lerp(currentStepStartRealPosition.x, currentStepEndRealPosition.x, ratio)
        local y                                = mapTankMovement.lerp(currentStepStartRealPosition.y, currentStepEndRealPosition.y, ratio)
        local r                                = mapTankMovement.lerp(currentStepStartRealPosition.r, currentStepEndRealPosition.r, ratio)
        if mapTankMovement.distance(currentStepEndRealPosition.x, currentStepEndRealPosition.y, x, y) < 2 and math.abs(r - currentStepEndRealPosition.r) < 2 then
            -- Step completed
            x = currentStepEndRealPosition.x
            y = currentStepEndRealPosition.y
            r = currentStepEndRealPosition.r
            mapTankMovement.startPathStep(mapTankMovement.currentPathIndex + 1)
        end
        return { x = x, y = y, r = r }
    end

    -- ---------------------------------------------
    -- Private functions
    -- ---------------------------------------------
    ---@private
    function mapTankMovement.getInitialPosition()
        return mapTankMovement.getRealPosition(mapTankMovement.initialPosition[mapTankMovement.level].x, mapTankMovement.initialPosition[mapTankMovement.level].y, mapTankMovement.initialPosition[mapTankMovement.level].r)
    end

    ---@private
    ---@param positionX number
    ---@param positionY number
    function mapTankMovement.getRealPosition(positionX, positionY, rotation)
        return { x = ((positionX - 1) * 64) + 32, y = ((positionY - 1) * 64) + 30, r = rotation }
    end

    ---@private
    function mapTankMovement.lerp(a, b, t)
        return a + (b - a) * t
    end

    ---@private
    function mapTankMovement.distance(x1, y1, x2, y2)
        return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    end

    return mapTankMovement
end

return MapTankMovement
