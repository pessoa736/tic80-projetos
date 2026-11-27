
local maindir="H:/Meu Drive/tic-80/appdata/"
function addPath(dir)
	package.path = package.path ..";" .. maindir.. dir .. "/?.lua"
end

addPath("libraries")
addPath("projetos")
addPath("projetos/3d_engine")

local m = {}

m.vec2 = require("vec2")
m.vec3 = require("vec3")

m.mat, m.matT = require("matriz")
m.lerp = function(a,b,t)
    return a*(1-t)+b*t
end
m.cos, m.sin, m.tan, m.max, m.min, m.abs = math.cos, math.sin, math.tan, math.max, math.min, math.abs
m.pi = math.pi
m.cot, m.sec, m.csc = function(a) return 1/tan(a) end, function(a) return 1/cos(a) end, function(a) return 1/sin(a) end

function m.rotate2d(p, a)
 return 
  p.x*m.cos(a) + p.y*m.sin(a),
  p.x*m.sin(a) - p.y*m.cos(a)
end

function m.rotate3d(a,b,y)
    local sa, ca = m.sin(a), m.cos(a)
    local sb, cb = m.sin(b), m.cos(b)
    local sy, cy = m.sin(y), m.cos(y)		
   
    local rx = m.mat(4,4)
        rx[1][1] = 1
        rx[2][2] = ca; rx[2][3] = -sa;
        rx[3][2] = sa; rx[3][3] = ca;
       
    local rz = m.mat(4,4)
        rz[1][1] = cy;	rz[1][2] = -sy;
        rz[2][1] = sy;	rz[2][2] = cy;
        rz[3][3] = 1
       
    local ry = m.mat(4,4)
        ry[1][1] = cb; ry[1][3] = sb;
        ry[2][2] = 1;
        ry[3][1] = -sb; ry[3][3] = cb;
       
       
   local r = rx * rz * ry		
       
   return r
end

return m