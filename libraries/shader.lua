-- title:   Matrix Shader
-- author:  xpudding
-- desc:    Draws matrices as scaled pixels with And/Or operations
-- site:    https://github.com/pessoa736/tic80-projetos
-- license: MIT License
-- version: 0.1
-- script:  lua
-- [resumo]
-- shader: desenha uma matriz (ver matriz.lua) na tela como pixels com escala,
-- e define operações entre matrizes (shader.And / shader.Or).
-- Nota: package.path está fixo em G:/Meu Drive/... (caminho do Windows antigo).
-- ------------------------------------------------------------
t=0
local diretorio = "G:/Meu Drive/tic-80/appdata/projetos/shaders/?.lua"
package.path = package.path .. ";" .. diretorio

local matriz = require("matriz")

shader = {}
function shader.draw(m,x,y,s)
	local s = s or 1
 	for i = 1, m.i do
  	for j = 1, m.j do
   		for sx = 1, s do 
    		for sy = 1, s do
				pix(
      				x+sx+i*s,
      				y+sy+j*s,
      				m:get(i,j)
    			)
    		end
   		end
  	end
 	end
end

function shader.And(m1, m2)
	local nm
	if m1==m2 then
		nm = matriz(m1.i, m2.j)
		for i = 1, nm.i do
		for j = 1, nm.j do
			if m1:get(i, j) == m2:get(i, j) then
				nm:set(i, j, m1:get(i, j))
			end
		end
		end
	end
end
function shader.Or(m1, m2)
	local nm
	if m1==m2 then
		nm = matriz(m1.i, m2.j)
		for i = 1, nm.i do
		for j = 1, nm.j do
			if m1:get(i, j) ~= m2:get(i, j) then
				nm:set(i, j, m1:get(i, j))
			end
		end
		end
	end
end

return shader

