---@class DataGrid
DataGrid = {}

DataGrid.new = function()
    local dataGrid = {}

    setmetatable(dataGrid, DataGrid)
    DataGrid.__index = DataGrid

    -- Properties

    -- functions

    return dataGrid
end

return DataGrid
