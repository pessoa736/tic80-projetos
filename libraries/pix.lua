

function Pix(x, y, c) end

vector = {}

vector.__add = function(a, b)
    return Pix(a.x+b.x, a.y+b.y, a.c+b.c)
end

vector.__sub = function(a, b)
    return Pix(a.x-b.x, a.y-b.y, a.c-b.c)
end

vector.__mul = function(a, b)
   return Pix(a.x*b.x, a.y*b.y, a.c*b.c)
end

vector.__div = function(a, b)
   return Pix(a.x/b.x, a.y/b.y, a.c/b.c)
end

vector.__unm = function(a)
    return Pix(-a.x, -a.y, -a.c)
end


vector.__eq = function(a, b)
 return a.x==b.x and a.y==b.y and a.c==b.c
end

vector.__newindex = function ()
    return Pix(0,0,0)
end

vector.__index=vector

function Pix(x,y,c)
 local v={x=x or 0, y=y or 0, c=c or 0}
 setmetatable(v,vector)
 return v
end