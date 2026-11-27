-- [resumo]
-- vec3: vetor 3D com operadores sobrecarregados via metatable. vec3(x, y, z).
-- Usado pela 3d_engine.
-- ------------------------------------------------------------


function vec3(x, y, z) end

local vector = {}

vector.__add = function(a, b)
    return vec3(a.x+b.x, a.y+b.y, a.z+b.z)
end

vector.__sub = function(a, b)
    return vec3(a.x-b.x, a.y-b.y, a.z-b.z)
end

vector.__mul = function(a, b)
    if type(b) =="table" then
     return vec3(a.x*b.x,a.y*b.y,a.z*b.z)
    else
     return vec3(a.x*b,a.y*b,a.z*b)
    end	
end

vector.__div = function(a, b)
    if type(b) =="table" then
    return vec3(a.x/b.x, a.y/b.y, a.z/b.z)
    else
    return vec3(a.x/b, a.y/b, a.z/b)
    end
end

vector.__idiv = function(a, b)
    if type(b) =="table" then
        return vec3(a.x//b.x, a.y//b.y, a.z//b.z)
    else
     return vec3(a.x//b, a.y//b, a.z//b)
    end
end

vector.__unm = function(a)
    return vec3(-a.x, -a.y, -a.z)
end


vector.__eq = function(a, b)
 return a.x==b.x and a.y==b.y and a.z==b.z
end

vector.__newindex = function ()
    return vec3(0,0)
end

vector.__index=vector

function vec3(x,y,z)
 local v={x=x or 0, y=y or 0, z=z or 0}
 setmetatable(v,vector)
 return v
end

return vec3 