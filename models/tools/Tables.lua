---@class Tables
Tables = {}

---@public
--- Fusionne deux tables.
---@param table1 table
---@param table2 table
function Tables.merge(table1, table2)
    for k, v in pairs(table2) do
        table1[k] = v
    end
    return table1
end

return Tables
