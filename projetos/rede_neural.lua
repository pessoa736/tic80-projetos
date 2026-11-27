-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

function new_ia(ninp,nocu, nout)
	local function new_input(size)
		local inp = {
			set = function(s, index, value)
				s[index] = value
			end
			}
		for i = 1, size do
			inp[i] = 0
		end
		return inp
	end
	
	local function new_peso(ninp, nout)
		local p = {
			create = function()
				for i = 1, ninp * nout do
					p[i] = math.random(-100, 100)/100
				end
			end
		}
		return p
	end
	
	local function new_ocult(inp, pe, size)
		local o = {
			update = function(s, index, indVal, indpesadd)
				local bia = math.random(-10, 10)/10
				s[index] = 0 
				for indVal = 1, indVal do  
					for indpes = 1, indVal do
						s[index] = s[index] + inp[indVal] * pe[indpes + indpesadd] + bia
					end
				end
				if s[index] < 0 then s[index] = 0 end
			end
		}
		for i = 1, size do
			o[i] = 0
		end
		return o
	end
	
	local function output(inp, pe, size)
		return new_ocult(inp, pe, size)
	end
	
	local rn = {
		update = function(s)
			for n = 1, nocu do
				s.ocu:update(n, ninp, (n - 1) * ninp) 
			end
			
			for	n = 1, nout do
				s.out:update(n, nocu, (n - 1) * nocu) 
			end
		end
	}
		rn.inp = new_input(ninp)
		rn.ocu = new_ocult(rn.inp, rn.pe1, nocu)
		rn.out = output(rn.ocu, rn.pe2, nout)
		rn.pe1 = new_peso(ninp, nocu)
		rn.pe2 = new_peso(nocu, nout)
		
	
	return	rn
end
   
function new_bot(seed)
	local bot = {
		add = function(s, x, y)
			local seed = seed or tstamp()
			local b={}
				b.x = x or 240 * 0.1
				b.y = y or 136 * 0.1
				b.vx = 0
				b.vy = 0
				b.spd = 1
			
				math.randomseed(seed)
				b.brain = new_ia(3, 4, 4)
				math.randomseed(tstamp())
			
			table.insert(s, b)
		end,
		update = function(s)
			for k, b in ipairs(s) do
				b.brain.inp[1] = ((b.x / 240) - (plr.x / 240))
				b.brain.inp[2] = ((b.y / 136) - (plr.y / 136))
				b.brain.inp[3] = math.atan(plr.x - b.x, plr.y - b.y)
				
				b.brain:update()
				rect(b.x,b.y,7,7,2)
			end
		end
		
	}
	return bot
end

plr={
	x = 240 * 0.9,
	y = 136 * 0.9,
	update = function(s)
		if btn(0) then s.y=s.y-1 end
		if btn(1) then s.y=s.y+1 end
		if btn(2) then s.x=s.x-1 end
		if btn(3) then s.x=s.x+1 end
		rect(s.x,s.y,7,7,12)
	end
}

bot01=new_bot()
	
function BOOT()
	bot01:add()
end

function TIC()
	cls()
	plr:update()
	bot01:update()
end
   
-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
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

