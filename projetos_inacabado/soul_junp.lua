-- title:  soul junp
-- author: xpudding
-- desc:   short description
-- script: lua

cell = 8

scam = {}
scam.x, scam.y = 0, 0
scam.w, scam.h = 240, 136

function lerp(a, b, t)
	return a*(t-1)+b*t
end

function vector2(x, y)
	local s = {}
		s.x = x or 0
		s.y = y or 0
	return s
end

entity = {}
function PlayerCrate(pos, v, a, input)
	local plr = {}
		plr.x = pos.x or 0
		plr.y = pos.y or 0
		plr.vx = v.x or 0
		plr.vy = v.y or 0
		plr.ax = a.x or 0
		plr.ay = a.y or 0
		plr.spd = 1.2
		
		plr.input = input or {[0]=58, [1]=59, [2]=60, [3]=61, [4]=1, [5]=19, [6]=24, [7]=26}
		function plr:move()
			if key(plr.input[2]) then
				if plr.vx < (plr.spd*3) then 
					plr.ax = -plr.spd
				end
			elseif key(plr.input[3]) then
				if plr.vx > -(plr.spd*3) then
					plr.ax = plr.spd
				end
			else
				plr.ax = 0
				plr.vx = 0
			end
			
			plr.vx = plr.vx + (plr.ax/60)
			plr.vy = plr.vy + (plr.ay/60)
			plr.x = plr.x + plr.vx
			plr.y = plr.y + plr.vy
		end
		
		plr.spr = 256
		function plr:draw()
			spr(plr.spr, plr.x, plr.y)
		end
	
	table.insert(entity, plr)
end

function entity:update()
	for k, s in ipairs(entity) do
			s:move()
	end
end
function entity:draw()
	for k, s in ipairs(entity) do
			s:draw()
			print(s.x)
			print(s.vx, 0, 8)
			print(s.ax, 0, 16)
	end
end

function init()
	PlayerCrate(vector2(0, 0), vector2(0, 0), vector2(0, 0))
end

init()
function TIC()
	entity:update()
	cls(12)
	entity:draw()
end



-- <SPRITES>
-- 000:2222222222222222222222222222222222222222222222222222222222222222
-- </SPRITES>

-- <PALETTE>
-- 000:0000005d005db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f4142022161c16030c07
-- </PALETTE>

