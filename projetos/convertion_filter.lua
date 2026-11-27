-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua
-- [resumo]
-- convertion_filter: convolução 2D (filtro 3x3) sobre a tela.
-- C_matriz cria matrizes, convection_matriz aplica o kernel `filter` em cada ponto
-- (sum_matriz_in_one_point). O TIC() desenha círculos animados, copia os pixels
-- para uma matriz e aplica o filtro -- experimento de processamento de imagem.
-- ------------------------------------------------------------

function lerp(a,b,t)
	return a*(1-t)+b*t
end

function C_matriz(i, j)
	local M = {
		i=i,
		j=j,
		set = function(s, i, j, n)
			s[i][j] = n
		end
	}
	for i = 0, i do
		M[i]={}
		for j = 0, j do
			M[i][j] = 0	
		end
	end
	return M
end

filter = C_matriz(2, 2)

filter:set(0, 0,  0.1); filter:set(1, 0,   0.1); filter:set(2, 0,   0.1);
filter:set(0, 1,  0.1); filter:set(1, 1,  0.35); filter:set(2, 1, -0.05);
filter:set(0, 2,  0.1); filter:set(1, 2, -0.05); filter:set(2, 2, -0.05);

function sget(x,y)
	local addr=0x4000+(x//8+y//8*16)*32 -- get sprite address
	return peek4(addr*2+x%8+y%8*8) -- get sprite pixel
end

spr_ = C_matriz(15,15)

for i = 0, spr_.i do
	for j = 0, spr_.j do
		spr_:set(i, j, sget(i, j))
	end
end

function sum_matriz_in_one_point(m1,m2,i,j)
	local p=0
	local k=0
	for i1=0, m2.i do
		if type(m1[i+i1])=="table" then
			for j1=0, m2.j do
				if type(m1[i+i1][j+j1])=="number" then
					p = p + m1[i+i1][j+j1]*m2[i1][j1]
					k=k+1
				end
			end
		end
	end
	return p
end

function convection_matriz(m, fm)
	local np = C_matriz(m.i, m.j)
	for i = 0, m.i do
		np[i]={}
		for j = 0, m.j do
			np[i][j] = sum_matriz_in_one_point(m, fm, i, j)
		end
	end
	return np
end

screem = C_matriz(239, 135)

t=0
function TIC()
	cls()

	for i = 0, 1, 0.05 do
		local x = lerp(0, 240, i)
		circ(x, 65, i*((t+(i/0.05))%30), 16*i)
	end

	for i=0, 239 do
		for j = 0, 135 do
		screem:set(i,j, pix(i,j))
		end
	end
	imagem_modify=convection_matriz(screem, filter)
	for i=0, imagem_modify.i do
		for j = 0, imagem_modify.j do
			pix(i,j,imagem_modify[i][j])
		end
	end
	t=t+1
end

-- <TILES>
-- 000:0000000011111111222222223333333344444444555555556666666677777777
-- 001:0000000011111111222222223333333344444444555555556666666677777777
-- 016:8888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
-- 017:8888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:0000001122332244663366994488cc55aaff66ccee77ee8888ff8899dd55abbb22bb9911cc7744dd5577ee33aaff11dd
-- </PALETTE>

