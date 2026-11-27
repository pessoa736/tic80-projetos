-- author: xpudding
-- script: lua
function vec2(x, y) end

local meta = {}

meta.__add = function(a, b)
    return vec2(a.x+b.x,a.y+b.y)
end

meta.__sub = function(a, b)
    return vec2(a.x-b.x,a.y-b.y)
end

meta.__mul = function(a, b)
    if type(b) =="table" then
     return vec2(a.x*b.x,a.y*b.y)
    else
     return vec2(a.x*b,a.y*b)
    end	
end

meta.__div = function(a, b)
    if type(b) =="table" then
        return vec2(a.x/b.x,a.y/b.y)
    else
        return vec2(a.x/b,a.y/b)
    end
end

meta.__mod = function(a, b)
    return vec2(a.x%b.x,a.y%b.y)
end

meta.__pow = function(a, b)
    return vec2(a.x^b.x,a.y^b.y)
end

meta.__unm = function(a)
    return vec2(-a.x,-a.y)
end

meta.__idiv = function(a, b)
    if type(b) =="table" then
     return vec2(a.x//b.x,a.y//b.y)
    else
    return vec2(a.x//b,a.y//b)
    end
end

meta.__tostring = function(a)
    return "x: ".. a.x .."  y: ".. a.y
end

meta.__eq = function(a, b)
    if a.x==b.x and a.y==b.y then
        return true
    end
end

meta.__newindex = function ()
    return v2(0,0)
end

function vec2(x,y)
 local v={x=x or 0,y=y or 0}
 setmetatable(v,meta)
 return v
end

return vec2

