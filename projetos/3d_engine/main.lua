-- title:   
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua


maindir="H:/Meu Drive/tic-80/appdata/"
function addPath(dir)
	package.path = package.path ..";" .. maindir.. dir .. "/?.lua"
end

addPath("libraries")
addPath("projetos")
addPath("projetos/3d_engine")

local pj = require("projecao")
require("drawing")

local ma = require("math")

function bt(n, k)
 	local result
	local f

	if k then
		f = key
	else
		f =btn
	end
	
 	if f(n) then
  		result = 1
 	else
  		result = 0
 	end
 	return result
end

function createCube(p, scale)
	local c={}
 	c.pos = p.pos or ma.vec3(0,0,0)
	c.mesh={}

	local l=1
	for i = -1, 1, 2 do
		for j = -1, 1, 2 do
			for k = -1, 1, 2 do
				c.mesh[l] = ma.vec3(i,j,k)*scale 
				l=l+1
			end
		end
	end
	
	c.faces = {  
		  [1] = {c.mesh[1], c.mesh[2], c.mesh[3], c.mesh[4]},
		  [2] = {c.mesh[5], c.mesh[6], c.mesh[7], c.mesh[8]},
		  [3] = {c.mesh[1], c.mesh[3], c.mesh[5], c.mesh[7]},
		  [4] = {c.mesh[2], c.mesh[4], c.mesh[6], c.mesh[8]},
		  [5] = {c.mesh[1], c.mesh[2], c.mesh[5], c.mesh[6]},
		  [6] = {c.mesh[3], c.mesh[4], c.mesh[7], c.mesh[8]
		}
	}
	function c:prerender()
		pj.sortfaces(self.faces)
	end
	
	function c:draw()
		for _, f in ipairs(self.faces) do
		  	Rect(f)
		end
	end
	return c
end


mou = {
	p1 = ma.vec2(),
	p2 = ma.vec2(),
	v = ma.vec2(),
	l = false,
	r = false,
	update = function(s)
		if t%2 == 0 then
			s.p2.x, s.p2.y, l = mouse()
		end
		if l then
			s.v = (s.p2-s.p1)/60
		end
		s.p1.x, s.p1.y, l = mouse()
	end
}



cam={
	pos = ma.vec3(0, 0, 4),
	angle = ma.vec3(0, 0, 0),
	update = function(self, moviment, Angle)
	   self.angle = self.angle + ma.vec3(Angle.y, Angle.x, Angle.z)
	   local p = ma.mat(4,1)
		   p[1][1] = moviment.x 
		   p[2][1] = moviment.y 
		   p[3][1] = moviment.z 
			p[4][1] = 1
	
	   local r = ma.rotate3d(self.angle.x, self.angle.y, self.angle.z)
	   local m = r*p
	
	   self.pos = self.pos + ma.vec3(m[1][1], 0, m[3][1])
	end
}

function BOOT()
 	t = 0
 	cube = createCube(vec3(1, -1, 1), ma.vec3(1,1,1))
end


function OVR()
 	cls()
	cube:draw()
end

function SCN(s)
	cls()
 	local sm = (s/136)
 	poke(0x03fc0, lerp(0x0ff, 0x000, sm))
 	poke(0x03fc1, lerp(0x0cd, 0x000, sm))
end

BDR_tick = 0
function BDR()
	if BDR_tick%10 == 0 then
		cube:prerender()
	end 
	BDR_tick = BDR_tick + 1
end

function TIC()
	cam:update(
	   ma.vec3(
		   (bt(4, true)-bt(1, true))/15,
		   0,
		   (bt(19, true)-bt(23, true))/15
	   ), 
	   ma.vec3(
		   (bt(45, true)-bt(46, true))/20, 
		   0, 
		   0
	   )
   	)
	mou:update()
 	t=t+1
  
end