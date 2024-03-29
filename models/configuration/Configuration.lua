---@class Configuration
Configuration = {}

Configuration.new = function()
    local configuration = {}

    setmetatable(configuration, Configuration)
    Configuration.__index = Configuration

    -- Properties

    -- functions

    return configuration
end

return Configuration
