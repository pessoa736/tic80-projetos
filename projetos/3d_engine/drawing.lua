
local maindir="H:/Meu Drive/tic-80/appdata/"
function addPath(dir)
	package.path = package.path ..";" .. maindir.. dir .. "/?.lua"
end

addPath("libraries")
addPath("projetos")
addPath("projetos/3d_engine")

local ma = require("math")
local pj = require("projecao")

local function convert_vec3_to_vec2(vector)
	local v = vector or ma.vec3(0,0,0)
	return ma.vec2(vector.x/vector.z, vector.y/vector.z)
end

local function setline(p1,c1,p2,c2)
	local line_={}
	local pointPos = ma.vec2()
	for i = 0, 1, 0.01 do
	
		pointPos =  ma.lerp(p1, p2, i)
    		line_[pointPos.x] = {}
      		line_[pointPos.x][pointPos.y] = {c = ma.lerp(c1, c2, i)}
    
  		function line_.draw()
     		for x, inx in ipairs(line_) do
        		for y, p in ipairs(inx) do
          			pix(x, y, p.c)
        		end
      		end  
    	end
    
    	function line_.getpix(i)
			local pointPos =  ma.lerp(convert_vec3_to_vec2(p1), convert_vec3_to_vec2(p2), i)
    		return pointPos, ma.lerp(c1, c2, i)
    	end
	end
  	return line_
end

function triangle(p1,p2,p3)
	local l1 = setline(p1.pos, p1.c, p2.pos, p2.c)
	local l2 = setline(p1.pos, p1.c, p3.pos, p3.c)
	local l3 = {}
	local pointPos = ma.vec2(0,0)

	local inter = ma.max(((p1.pos.z+p2.pos.z+p3.pos.z)/3 - ma.abs(cam.pos.z)), 0.05)
	
	if ma.min(p1.pos.z, ma.min(p2.pos.z, p3.pos.z))>=0 then 
		for i=0, 1, inter do
			
			local p1, p1c = l1.getpix(i)
			local p2, p2c = l2.getpix(i)
			
			for j = 0, 1, inter do
				local pointPos =  ma.lerp(p1, p2, j)
				local c =  ma.lerp(p1c, p2c, j)
				pix(pointPos.x+120, pointPos.y+68,c)
			end
		end
	end
end

function Rect(f)
    local nf = {}
   for i=1,4 do
         nf[i] = pj.cpo(
          f[i],
          ma.vec3(0,0,0),
          i
      )
    end
    local f = nf
    triangle(f[1], f[2], f[3])
    triangle(f[4], f[2], f[3])
end