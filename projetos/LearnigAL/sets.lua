local SETS = {}

local Set = {}
Set.__index = Set

function Set:contains(v)
    return self.criterio(v)
end

function Set:createSubSet(predicado)
    return SETS.createSet(function(v)
        return self:contains(v) and predicado(v)
    end)
end

function Set:__call(v)
    return self:contains(v)
end

function SETS.createSet(data)
    local criterio

    if type(data) == "table" then
        criterio = function(v)
            for _, x in ipairs(data) do
                if x == v then
                    return true
                end
            end
            return false
        end
    else
        criterio = data or function()
            return false
        end
    end

    return setmetatable({
        criterio = criterio
    }, Set)
end

_G["NaturalSET"] = SETS.createSet(function (v)
        if type(v) ~= "number" then  return false end
        if v<0 then return false end
        return math.tointeger(v) == v
    end
)

_G["IntegersSET"] = SETS.createSet(function (v)
        if type(v) ~= "number" then  return false end

        return math.tointeger(v) == v
    end
)

_G["RationalSET"] = SETS.createSet(function (v)
        if type(v) ~= "number" then  return false end
        if math.tointeger(v) == v then  return true end

        local h1, h2 = 1, 0
        local k1, k2 = 0, 1
        local b = v
        local tolerance = 1e-9

        repeat
            local a = math.floor(b)
            
            local aux = h1
            h1 = a * h1 + h2
            h2 = aux
            
            aux = k1
            k1 = a * k1 + k2
            k2 = aux 

            if b - a < 1e-15 then break end
            
            b = 1 / (b - a)
        until math.abs(v - h1 / k1) <= tolerance or b > 1e7
        
        return math.abs(v - h1 / k1)*10 <= tolerance

    end
)

_G["IrrationalSET"] = SETS.createSet(function (v)
        if type(v) ~= "number" then return false end
        return not RationalSET.criterio(v)
    end
)

_G["RealSET"] = SETS.createSet(function (v)
        return 
            NaturalSET.criterio(v) or
            IntegersSET.criterio(v) or
            RationalSET.criterio(v) or
            IrrationalSET.criterio(v)
    end
)

_G["ComplexSET"] = SETS.createSet(
    ---@class complex: table
    ---@field a number
    ---@field bi number

    ---@param v complex | number
    ---@return boolean
    function (v)
        if type(v) == "number" then return RealSET.criterio(v) end
        if type(v) == "table" then 
            for k, _v in pairs(v) do
                if k ~= "a" or k ~= "b" then return false end
                if 
                    (type(_v) ~="number" and type(_v) ~="nil") 
                then
                    return false 
                end
            end
            if #v <= 0 then return false end
        end
         
        return true
    end
)





return SETS