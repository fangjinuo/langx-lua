---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by fangjinuo.
--- DateTime: 2021/2/26 15:05
---

local Objs = require("Objs")
local Functions = require("Functions")
local Collects = {}

--- traverse a table
--- @overload fun(table:string|function, consumer:function):table
---
--- @param table table|function a table or a iterator function
--- @param consumePredicate function a predicate with two arguments: key, value, when it match, will do do with the consumer
--- @param consumer function a consumer with two arguments: key, value
--- @param breakPredicate function a predicate with two arguments: key,value
--- @param traverseUsingIndex boolean traverse using index (ipairs), default true
function Collects.forEach(table, consumePredicate, consumer, breakPredicate, traverseUsingIndex)
    if (Objs.isNull(table)) then
        return
    end
    if (Objs.isNull(consumer) and Objs.isNull(breakPredicate) and Objs.isFunction(consumePredicate)) then
        consumer = consumePredicate;
        consumePredicate = nil;
    end

    if (Objs.isNull(consumePredicate)) then
        consumePredicate = Functions.truePredicate
    end

    if (Objs.isNull(breakPredicate)) then
        breakPredicate = Functions.falsePredicate;
    end

    if (Objs.isNull(consumer)) then
        return
    end
    if ((not Objs.isFunction(consumePredicate)) or (not Objs.isFunction(breakPredicate))) then
        return
    end

    if (Objs.isFunction(table)) then
        local generator = table
        local index = 0

        while (true) do
            index = index + 1
            local value = generator()
            if (value == nil) then
                break
            end
            if (consumePredicate(index, value)) then
                consumer(index, value)
                if (breakPredicate(index, value)) then
                    break ;
                end
            end
        end
    else
        if (not traverseUsingIndex) then
            for key, value in pairs(table) do
                if (consumePredicate(key, value)) then
                    consumer(key, value)
                    if (breakPredicate(key, value)) then
                        break ;
                    end
                end
            end
        else
            for key, value in ipairs(table) do
                if (consumePredicate(key, value)) then
                    consumer(key, value)
                    if (breakPredicate(key, value)) then
                        break ;
                    end
                end
            end
        end
    end
end

--- filter a table
--- @param table table the table
--- @param predicate function a predicate function
--- @return table an new table
function Collects.filter(table, predicate)
    return Collects.filterN(table, predicate, -1);
end

--- filter a table, find n items
--- @param table table a table
--- @param predicate function the predicate
--- @param n number an integer,  if n < 0, will not length limit, if n = 0 , will not do filter
--- @return table an new table
function Collects.filterN(table, predicate, n)
    if (Objs.isNull(table) or Objs.isNull(predicate)) then
        return table or {}
    end

    if (Objs.isNull(n)) then
        n = -1;
    end
    if (not Objs.isNumber(n)) then
        n = -1;
    end

    if (n == 0) then
        return table;
    end

    local newTable = {};
    local consumer = function(key, value)
        newTable[key] = value;
    end

    local breakPredicate = Functions.falsePredicate;
    if (n > 0) then
        breakPredicate = function()
            return rawlen(newTable) >= n
        end
    end
    Collects.forEach(table, predicate, consumer, breakPredicate);
    return newTable;
end

--- do map
--- @param table table a table
--- @param mapper function a mapper function
--- @return table an new table
function Collects.map(table, mapper)
    if (Objs.isNull(table) or Objs.isNull(mapper)) then
        return table or {}
    end

    local newTable = {}
    local consumer = function(key, value)
        local key1, value1 = mapper(key, value);
        newTable[key1] = value1;
    end
    Collects.forEach(table, Functions.truePredicate, consumer)
    return newTable
end




return Collects;