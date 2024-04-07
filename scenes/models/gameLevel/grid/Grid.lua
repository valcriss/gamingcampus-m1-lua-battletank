---@class Grid
Grid     = {}

Grid.new = function(width, height, cellSize, data)
    local grid = {
        width    = width,
        height   = height,
        data     = data,
        cellSize = cellSize,
        cells    = {}
    }

    setmetatable(grid, Grid)
    Grid.__index = Grid

    return grid
end

return Grid
