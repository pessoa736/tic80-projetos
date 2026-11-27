-- [resumo]
-- 3d_engine/projecao: projeção das faces para a tela.
-- pj.calcdepth (profundidade média da face, via matrizes), pj.sortfaces
-- (ordena de trás pra frente -- algoritmo do pintor) e pj.cpo.
-- ------------------------------------------------------------

local maindir="H:/Meu Drive/tic-80/appdata/"
function addPath(dir)
	package.path = package.path ..";" .. maindir.. dir .. "/?.lua"
end

addPath("libraries")
addPath("projetos")
addPath("projetos/3d_engine")

local ma = require("math")

local pj = {}

function pj.calcdepth(f)
	local posfaces = (f[1] + f[2] + f[3] + f[4])/4
	local p = ma.mat(4,1)
	p[1][1] = posfaces.x
	p[2][1] = posfaces.y
	p[3][1] = posfaces.z
	p[4][1] = 1
	
	local r = ma.rotate3d(cam.angle.x, cam.angle.y, cam.angle.z)
	
	local d = r*p
	return (d[3][1])
end

function pj.sortfaces(faces)
 table.sort(faces, 
  function (a, b)
   
   if (pj.calcdepth(a))<(pj.calcdepth(b)) then
    return true
   end
  end
 )
end


function pj.cpo(p,pos,c)
	local newpos = cam.pos - p+pos
		
 	local fov = 90
  	local aspect = 136/240
  	local ff, fn = 0.25, 0.1
  
  	local m = ma.mat(4,4)
  		m[1][1] = sec(1)/aspect
  		m[2][2] = sec(1)/aspect
  		m[3][3] = (ff+fn)/(ff-fn)
		m[4][3] = 1
		m[4][4] = 1
 		m[3][4] = (ff*fn)/(ff-fn)
  
  	local p = ma.mat(1,4)
  		p[1][1] = newpos.x
  		p[1][2] = newpos.y
  		p[1][3] = newpos.z
  		p[1][4] = 1
  
  	local nm = m*ma.matT(p)
  	local r = ma.rotate3d(cam.angle.x, cam.angle.y, cam.angle.z)
	local nm = r*nm
	
	return {
		pos = ma.vec3(nm[1][1], nm[2][1], nm[3][1]	*0.01), 
		c = p.c or c
	}
end

return pj