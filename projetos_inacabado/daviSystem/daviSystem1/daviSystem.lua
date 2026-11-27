-- title:   daviSystem
-- author:  xpudding
-- desc:    Fictional operating system with windows, taskbar and start menu
-- site:    https://github.com/pessoa736/tic80-projetos
-- license: MIT License
-- version: 0.1
-- script:  lua
-- [resumo]
-- daviSystem 1: sistema operacional fictício em TIC-80 (inacabado).
-- Workspace com wallpaper, janelas (windows), barra de tarefas com data/hora (unix),
-- menu iniciar e apps registrados por createAPP(app, iconString) -- o ícone é uma
-- string hexadecimal de 64 caracteres (8x8). Instruções no AddAppOrGame().
-- ------------------------------------------------------------

joystick = false
scamx, scamy = 240, 136
cell = 8
rows, cols = scamx//cell, scamy//cell

function AddAppOrGame()
	--use "createAPP(APP, iconString)" for add the games or app
	--	APP: game script in function format.
	--	iconString: string that draws 8x8 sprites where the maximum characters are 64, and must be in hexadecimal.
	
	--use "win:cls()" instead of "cls".
	--use "win:print()" instead of "print()".
	
	--[[
		example 1:
		
			createAPP(
				function(win --mandatory) 
					local title, author, desc = "example", "xpudding", "demonstration" 
					local HelloWorld = {}
					
					local function init()
						HelloWorld.string = "hello world"
						HelloWorld.x = 84
						HelloWorld.y = 84
						HelloWorld.color = 12
					end
					
					init()
					local function update() --works the same as the "TIC" function and it is mandatory
						win:cls(0)
						win:print(HelloWorld.string, HelloWorld.x, HelloWorld.y, HelloWorld.color)
					end
					
					return app.update, app.title, app.author, app.desc --mandatory
				end,
				"0000111122223333444455556666777788889999aaaabbbbccccddddeeeeffff" 
				)
				
		example 2:
		
			local function app(win --mandatory) 
				local title, author, desc = "example", "xpudding", "demonstration" 
				local HelloWorld = {}
				
				local function init()
					HelloWorld.string = "hello world"
					HelloWorld.x = 84
					HelloWorld.y = 84
					HelloWorld.color = 12
				end
				
				init()
				local function update() --works the same as the "TIC" function and it is mandatory
					win:cls(0)
					win:print(HelloWorld.string, HelloWorld.x, HelloWorld.y, HelloWorld.color)
				end
				
				return app.update, app.title, app.author, app.desc --mandatory
			end
			
			createAPP(app, "0000111122223333444455556666777788889999aaaabbbbccccddddeeeeffff")
	]]
end

imagems = {
	["icon"] = {
		[0x0] = {type = "string", name = "sprBug", str = [[111100011110000111100001111000000001111000011110000111100001111]]}
	},
	[0x0] = {type = "map", name = "wallpaper", x = 0, y = 0},
}

--mouse
m = {}
	m.x = 0
	m.y = 0
	m.l = false
	m.m = false
	m.r = false
	m.sprs = {
		["hand"] = 129,
		["ibeam"] = 130,
		[""] = 128 
	}
	m.state = m.sprs["hand"]
	
	function m:changeSpr(str)
		m.state = m.sprs[str]
	end

	function m:draw() 
		poke(0x03FFB, m.state)
		print(peek(0x03ffb))
	end

	function m:function_()
		m.x, m.y, m.l, m.m, m.r = mouse()
	end
--end of mouse functions

--workspace
workspace = {
	wallpaper = imagems[0x0],
	cell = 10,
	space = {}
}

function workspace.space:drawAPP()
	local cell = workspace.cell
	for k, app in ipairs(workspace.space) do
		app.workspace.x, app.workspace.y = 1+cell*((k//cell)%8), 1+((k//cell)//cell)*cell
		local x, y = app.workspace.x+(cell/2), app.workspace.y
		app:sprString(x, y)
		
		print(
			app.title:sub(1, 4).."...",
			app.workspace.x,
			app.workspace.y+cell,
			12,
			false,
			1,
			true
		) 
	end
end

function workspace.space:functionAPP()
	local cell = workspace.cell
	for k, app in ipairs(workspace.space) do
		for w = 0, cell do
			for h = 0, cell do
				if m.x == app.workspace.x+w and m.y == app.workspace.y+h then
					m:changeSpr("hand")
					if m.l==true then
						table.insert(windows, app)
					end
				end
			end
		end
	end
end

function workspace:draw()
	map(
		workspace.wallpaper.x,
		workspace.wallpaper.y,
		rows,
		cols
	)
end
--end of workspace functions

windows = {}
window = {x=0, y=0, w=scamx, h=scamy}
function windows:functionAPP()
	for k, app in ipairs(windows) do
		app.win._exit:exitAPP(k, function(id) table.remove(windows, id) end)
		app.update(app)
		rect(app.win.x,app.win.y,app.win.w,app.win.h-taskbar.y,12) 
		print(app.title,app.win.x+1,app.win.y+1)
		spr(2,app.win.x+app.win.w-8,0)
	end
end

apps = {}
function createAPP(APP, iconString)
	local backup={
		functionPrint=print
	}
	local app = {
		icon = iconString or imagems["icon"][0x0].str,
		scriptLoad = APP,
		workspace = {
			x = 0, y= 0
		},
		win = {
			x = window.x or 0,
			y = window.y or 0, 
			w = window.w or scamx, 
			h = window.h or scamy,
			cell=8,
			print = function(s, str, x, y, color, fixed, scale, smallfont)
				backup.functionPrint(str, (x or 0)+s.x, (y or 0)+s.y, color, fixed, scale, smallfont)
			end,
			cls = function(s, color)
				rect(s.x, s.y, s.w, s.h, color)
			end,
		},
		sprString = function(s, x, y, isolated_pixel)
			local cell = 8
			local sprstr = s.icon .. (tostring(isolated_pixel or pix(x+8,y+8)) or "1")
			
			for Str = 0, #sprstr-3 do	
				local w = ((Str-1)%cell)
				local broker = (w==7 and 1 or 0)
				local h = (((Str//cell)-broker)%cell)
				
				pix(x+w, y+h,tonumber(sprstr:sub(Str, Str), 16))
			end
		end,
	}
    app.win._exit = {
		x = app.win.x + app.win.w - app.win.cell,
		y = app.win.y,
		w = app.win.x + app.win.w,
		h = app.win.y + app.win.cell,
		exitAPP = function(s, id ,removefunction) 
			for w = s.x, s.w do
				for h = s.y, s.h do
					if w == m.x and h == m.y and m.l then
						app.win:reset()
						removefunction(id)
					elseif windows[id-1] == app then
						removefunction(id) 
					end
				end 
			end  
		end,
	}
	
	
	app.update, app.title, app.author, app.desc = app.scriptLoad(app.win)
	app.script = _VERSION
	
	function app.win:reset()
		app.update, app.title, app.author, app.desc = app.scriptLoad(app.win)
	end
	table.insert(workspace.space, app)
end
AddAppOrGame()

taskbar = {
	color = 15,
	x = 0,
	y = ((scamy*0.99)//8)*8,
	w = scamx,
	space = {},
}
taskbar.h = ((scamy-taskbar.y)//8)*8

start = {
	color = 15,
	x = 0,
	h = taskbar.y*0.5,
	w = scamx*0.5,
	visivel = false
}
start.y = (taskbar.y)-start.h


function taskbar:draw()
	rect(
		taskbar.x,
		taskbar.y,
		taskbar.w,
		taskbar.h,
		taskbar.color
	)
 
	--apps
	local space=0
	for k,s in pairs(taskbar.space) do
		spr(
			s.sprite,
			taskbar.x+space,
			taskbar.y,
			s.clk
		)
		space=space+8
	end
 
	--date 
	date=tstamp()
	local function get_date_from_unix(unix_time)
		local day_count, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(unix_time/86405)
		
		while days >= day_count(year) do
			days = days - day_count(year) year = year + 1
		end
		local tab_overflow = function(seed, table) for i = 1, #table do if seed - table[i] <= 0 then return i, 1+seed end seed = seed - table[i] end end
		month, days = tab_overflow(days, {31,(day_count(year) == 366 and 29 or 28),31,30,31,30,31,31,30,31,30,31})
		local hours, minutes, seconds = math.floor((unix_time-10000) / 3600 % 24), math.floor(unix_time / 60 % 60), math.floor(unix_time % 60)
		local period = hours > 12 and "pm" or "am"
		hours = hours > 12 and hours - 12 or hours == 0 and 12 or hours
		return string.format("%d/%d/%04d %02d:%02d:%02d %s", days, month, year, hours, minutes, seconds, period)
	end
 
	print(
		get_date_from_unix(date),--hour..":"..min,
		taskbar.w*0.665,
		taskbar.y+2,
		12,
		false,
		1,
		true
	)
end

function taskbar:function_()
	local space=0
	for k,s in pairs(taskbar.space) do
		local x=taskbar.x+space
		local y=taskbar.y
		local w=8
		local h=taskbar.h
 
		for w=0,w do
			for h=0,h do
				if x+w==m.x and y+h==m.y then
					m:changeSpr("hand")
					if m.l==true then
						s.function_()
					end
				end
			end
 
		end
		space=space+8
 
	end
end

function start:create()
	taskbar.space["start"] = {name="start", sprite=0, clk=0, function_=start.open}
end

function start:open()
	start.visivel = true
end

function start:close()
	local x, y, w, h = start.x, start.y, start.w, start.h
	if x+w < m.x or y+h < m.y or x > m.x or y > m.y then
		m:changeSpr("hand")
		if m.l==true or m.r==true then
			start.visivel = false
		end
	end
end

function start:draw()
	local x, y, w, h = start.x, start.y, start.w, start.h
	if start.visivel == true then
		rect(x, y, w, h, start.color)
	end
end

function create()
	start:create()
end

function initSystem()

	FakeTIC=system
end

function system()
	
	m:function_()
	taskbar:function_()
	start:close()
 
	--draw
	workspace:draw()
	workspace.space:drawAPP()
	workspace.space:functionAPP()
	windows:functionAPP()
	taskbar:draw()
	start:draw()
	m:draw()
	print(m.l)
end


FakeTIC = function() end
 
FakeTIC = initSystem
create() 
function TIC()
	m:changeSpr("")
	FakeTIC()
end

-- <TILES>
-- 000:0e0000e0ece00eceecceecceececceceeceeeeceece00eceece00ece0e0000e0
-- 001:0f000000fcf00000fccf0000fccf0000fcccf000fccf0000fcfcf0000f0f0000
-- 002:cccccccccffccffcccffffcccccffcccccffffcccffccffccfccccfccccccccc
-- 017:000f000000fcf00000fcf0000ffcccf0fcfccccf0fcccccf00fcccf0000fff00
-- 018:222222222ff22ff222ffff22222ff22222ffff222ff22ff22f2222f222222222
-- 224:bbbbbbbb66bbbbbb666666bb5566666666556666666655556666666656666666
-- 225:bbbbbbbbbbbbbbbbbbbbbbbb66bbbbbb66666bb5666666655556666666655566
-- 226:bbbbbbbbbbbbbbbbbbbbbb55bbb5555555555566555566656656555566665555
-- 227:bbbbbb55b5555655555665556665555655555565555556555556655555655556
-- 228:55bbbbbb5555565b555555666655555555655555555666556555556566555556
-- 229:bbbbbbbbbbbbbbbb55bbbbbb66555bbb55655555556555555556656666556666
-- 230:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb665bb66665566665566666566666665666
-- 231:bbbbbbbbbbbbbb66bb6666666666666555555556666666666666666666666666
-- 232:bbbbbbbbbbbbbcccbcccccffcfffccbbfbbbfcbbbbbbfccbbbbbbfcbbbbccccb
-- 233:bbbbbbbbccccbbbbfffccbbbbbbffcbbbbbbbfcbbbbbbfcbbbbbbbfcbbbbbbfc
-- 234:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccbbbb
-- 235:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 236:bbbbbbbbbbbbbbbbbbbbbbbbbbbbfccbbbbfcccbbbbfcffbbbbbfbbbbbbbbbbb
-- 240:6555566666666556666666656666666666666666666666666666666666666666
-- 241:6666655666666655556666666656666666656666666556666666656666666556
-- 242:6666665556666665655666556665555666655566666556656655665566556555
-- 243:5565555656555566655555655555565555556655555565555556655555665556
-- 244:5566555555565555555665555555666655556666556666666666666666666666
-- 245:5566666656666666666666666666665566666556666556666655666665666666
-- 246:6665666665566666566666555666655566666566666556666665666666556666
-- 247:6665555555556666566666666666666666666666666666666666666666666666
-- 248:bfccffccbfcfbfccbfccbcffbbfcccbbbbbfffbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 249:bbbbbbfccbbbbfccccbbbfcffccbcccfbfcccffbbbfffbbbbbbbbbbbbbbbbbbb
-- 250:cffccbfccbbfcbfcccbfccfccccccfccfffffbffbbbbbbbbbbbbbbbbbbbbbbbb
-- 251:cccbfccbffcbfcfbbfcbfcbbbfccccbbbfffffbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 252:bbbbbbbbbbbfcbbbbbfccbbbbfccccbbfccffccbbffbbffbbbbbbbbbbbbbbbbb
-- 253:bbbbbbbbbbbbbbbbbffbfbfbfccfcfcffcffcfcfbfcffcfbfccfcfbfbffbfbbb
-- 254:bbbbbbbbbbbbbbbbffbfffbfccfcccfccfbfcffcfcffcffcccffcffcffbbfbbf
-- 255:bbbbbbbbbbbbbbbbfbbfffbbdefcccfbcffcccfbfbfcfcfbcffcfcfbfbbfbfbb
-- </TILES>

-- <SPRITES>
-- 000:ffff1111ffff1111ffff1111ffff11111111ffff1111ffff1111ffff1111ffff
-- </SPRITES>

-- <MAP>
-- 000:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:bebebebebebebebebebebebe8e9ebebecebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:bebebebebebebebebebebebe8f9fafbfcfdfefffbebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:bebebebebebebebebebebebebebebebebebebebebebebebebebebebebebe0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e1e2e
-- 015:3e4e5e6e7e0e1e2e3e4e5e6e7e0e1e2e3e4e5e6e7e0e1e2e3e4e5e6e7e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e1e2e
-- 016:3f4f5f6f7f0f1f2f3f4f5f6f7f0f1f2f3f4f5f6f7f0f1f2f3f4f5f6f7f0f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f1f2f
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:0000005d005db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f4142022161c16030c07
-- </PALETTE>

