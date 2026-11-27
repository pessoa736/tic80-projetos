-- title:   cookieTICker
-- author:  xpudding
-- desc:    Cookie Clicker clone
-- site:    https://github.com/pessoa736/tic80-projetos
-- license: MIT License
-- version: 0.1
-- script:  lua
-- [resumo]
-- cookieTICker: clone de Cookie Clicker no TIC-80.
-- Biscoito central clicável (cookieCentral), construções/upgrades/loja (builds_hud,
-- upgrade_hud, store_hud) e botões com estilo 3D (rect2).
-- Nota: package.path fixo em G:/Meu Drive/... (caminho do Windows antigo).
-- ------------------------------------------------------------
local diretorio = "G:/Meu Drive/tic-80/appdata/projetos/cookie_clicker/?.lua"
package.path = package.path .. ";" .. diretorio

local button = require("button")
local m = require("math_addiction")


button.drawfunction = function(x, y, w, h, pressed) 
	if pressed then
		rect2(x, y, w, h, 0, 12)
	else
		rect2(x, y, w, h, 0, 14)
	end
end

scrw=240
scrh=136

t=0
cookies = 0
CpC = 1  
leftpressed = false
mouse_click = false
cookieClickerEffect = true

function click(n)
 cookies = cookies + (n	or 1)
end

cookieCentral = {}
	cookieCentral.rdefault = 30
	cookieCentral.r = cookieCentral.rdefault 
	cookieCentral.x = scrw*0.25 --- cookieCentral.r*0.5
	cookieCentral.y = scrh*0.5 -- cookieCentral.r*0.5 

function cookieCentral:draw()
	--click effect

	local d = m.distanceBivetor(self.x, self.y, mx, my)

	if cookieClickerEffect then
		if mouse_click then 
			if d < cookieCentral.r then
				if leftpressed ~= mouse_click then
					self.r = m.min( self.rdefault * 1.5, m.lerp( self.r, self.r*1.1, 0.5 ) )
				end
			end
		else
			self.r = m.lerp(self.r, self.rdefault, 0.1)
		end
	end
 
	--draw cookie
	local x, y, r = self.x, self.y, self.r
	
	circ(x,y,r,3)
	circ(x-r*0.5,y-r*0.5,r*0.3,2)
	circ(x+r*0.6,y+r*0.6,r*0.2,2)
	circ(x-r*0.45,y+r*0.45,r*0.35,2)
end

function player_click()
	local d = m.distanceBivetor(cookieCentral.x, cookieCentral.y, mx, my)
	
	if d< cookieCentral.r then
		if leftpressed ~= mouse_click then
			if mouse_click then
				click(CpC)
			end
		end
	end
end 

----
function add_builds(name, powercookies, spr, price)
	return { 
	 	name = name, powercookies = powercookies,
		 spr=spr, price = price, time = 1.5,
	 	funct = function(s)
			for k, b in ipairs(s.all) do
			 	if (t+#s.all)%(15*s.time)//1 == 1 then
					click(s.powercookies)
				end
			end
		end,
		buy = function(s)
			table.insert(s.all,{"cookie", n = #s.all+1})
		end,
		all={},
	}
end


function rect2(x,y,w,h,c1,c2)
 	rect(x,y,w,h,c2)
 	rect(x+1,y+1,w-2,h-2,c1)
end

builds={
	[1] = add_builds("cursos", 1, 1, 10),
	[2] = add_builds("farms", 5, 2, 150),
}

function builds_hud(hux,huy,huw,huh)
 	local i = 0
 	for k, bui in ipairs(builds) do
  		local bx, by = hux+2, huy+10+i*12+i*2
  		local bw, bh = huw-4,12
  
  		if button:pressed(bx, by, bw, bh, mx, my, mouse_click) then
			if cookies >= bui.price then 
				bui:buy()
				cookies = cookies - bui.price
				bui.price = (bui.price * 1.35)//1
			end
		end
		bui:funct()
  
		local c1, c2
  		if cookies >= bui.price then 
   			c1 = 12
   			c2 = 5
  		else
   			c1 = 14
   			c2 = 2
  		end

 		spr(bui.spr, bx+2, by+2, 0)
 		print(bui.name..": "..#bui.all, bx+12+2, by+3, c1)
 		print(bui.price, bx+bw*0.7, by+3, c2)
		i=i+1
	end
end


upgrades={
	[1] = {name = "cursors", multiply = 1, price = 350},
	[2] = {name = "farms", multiply = 1, price = 500}
}

function upgrade_hud(hux, huy, huw, huh)
	local i = 0
	for k, upgr in ipairs(upgrades) do
		local bx, by = hux+2, huy+10+i*12+i*2
		local bw, bh = huw-4,12
		
		if button:pressed(bx, by, bw, bh, mx, my, mouse_click)then
			if cookies >= upgr.price then	
				upgr.multiply = upgr.multiply + 0.05
				cookies = cookies - upgr.price
				upgr.price = (upgr.price * 1.35)//1
				builds[k].powercookies = upgr.multiply 
			end
		end
		local c1, c2
		if cookies >= upgr.price then 
			c1 = 12
			c2 = 5
		else
			c1 = 14
			c2 = 2
		end
		
		print(upgr.name..": ".. upgr.multiply .."X", bx+12+2, by+3, c1)
		print(upgr.price, bx+bw*0.7, by+3, c2)
		i=i+1
	end
end


store_bar = "builds"
function store_hud()
 	local hux, huy = scrw*0.5, 0
 	local huw, huh = scrw-hux, scrh-huy 
 
	rect2(hux,huy,huw,huh,0,12)
 	local b1, b2  
	if store_bar == "builds" then
 		builds_hud(hux,huy,huw,huh)
  		b1 = 12
  		b2 = 14
 	elseif store_bar == "upgrades" then
  		upgrade_hud(hux, huy, huw, huh)
  		b1 = 14
  		b2 = 12
 	end
 
 	local rs1 = #"builds"*6.5
 	local bx, by = hux, huh-9
 	local bw, bh = rs1, 9

 	print("builds", bx+2, by+2, b1)
	if button:pressed(bx, by, bw, bh, mx, my, mouse_click) then
	  	store_bar = "builds"
	end
	
 	local rs2 = #"upgrades"*6.5
 	local bx, by = hux+rs1, huh-9
 	local bw, bh = rs2, 9

 	print("upgrades", bx+2, by+2, b2)
 	if button:pressed(bx, by, bw, bh, mx, my, mouse_click) then
		store_bar = "upgrades"
	end
 
 	rect2(hux-2, huy, #"store"*6+4, 9, 0, 12)
	print("store", hux+1, huy+2, 12)
end

function TIC()
	mx = peek(0x0ff84)
	my = peek(0x0ff85)
 	mouse_click = peek(0x0ff86)==1
	
	player_click()
	
	cls(10)
	cookieCentral:draw()
	store_hud()
	
	local n = #tostring(cookies):sub(0,3)
	rect2(1,1,5*n+5,9, 0, 12)
	print(tostring(cookies):sub(0,3), 3, 3, 12)
	
	t=t+1
end
-- <TILES>
-- 001:00c0000000c0000000c0000000cccc00c0ccccc0ccccccc00cccccc000ccccc0
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
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

