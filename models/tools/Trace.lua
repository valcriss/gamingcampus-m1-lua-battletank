---@class Trace
Trace = {}

function Trace.printObject(object)
    print("-------------------------------------------------")
    print("Values of", object.properties.name)
    print("-------------------------------------------------")
    for key, value in pairs(object.values.keys) do
        print(value, "=", object.values[value])
    end

    print("-------------------------------------------------")
    print("Properties of", object.properties.name)
    print("-------------------------------------------------")
    for key, value in pairs(object.properties.keys) do
        if value ~= "script" then
            print(value, "=", object.properties[value])
        end
    end
    print("-------------------------------------------------")
end

function Trace.printTable(data)
    if type(data) == "table" then
        for key, value in pairs(data) do
            print(key .. ":")
            Trace.printTable(value)
        end
    else
        print(data)
    end
end

return Trace
