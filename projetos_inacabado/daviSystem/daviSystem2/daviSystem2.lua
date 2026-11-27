-- engine:         system Operactional engine
-- author:         xpuddine
-- license:        MIT License
-- engine version: 0.4
-- script:         lua
-- [resumo]
-- daviSystem 2 (engine v0.4, 'system Operactional engine'): reescrita do daviSystem
-- sobre a engine vec2/texrect/sprtex, com new_program e system:init/update/draw.
-- O cart correspondente é daviSystem2.tic na mesma pasta.
-- ------------------------------------------------------------

m=math

function vec2(x, y) end

local meta = {
 __add = function(a, b)if type(b)==type({}) then return vec2(a.x+b.x,a.y+b.y) else return vec2(a.x+b,a.y+b) end end,
 __sub = function(a, b)if type(b)==type({}) then return vec2(a.x-b.x,a.y-b.y) else return vec2(a.x-b,a.y-b) end end,
 __mul = function(a, b)if type(b)==type({}) then return vec2(a.x*b.x,a.y*b.y) else return vec2(a.x*b,a.y*b) end end,
 __div = function(a, b)if type(b)==type({}) then return vec2(a.x/b.x,a.y/b.y) else return vec2(a.x/b,a.y/b) end end,
 __mod = function(a, b)if type(b)==type({}) then return vec2(a.x%b.x,a.y%b.y) else return vec2(a.x%b,a.y%b) end end,
 __pow = function(a, b)if type(b)==type({}) then return vec2(a.x^b.x,a.y^b.y) else return vec2(a.x^b,a.y^b) end end,
 __unm = function(a)if type(b)==type({}) then return vec2(-a.x,-a.y) else return vec2(a.x+b,a.y+b) end end,
 __idiv = function(a, b)if type(b)==type({}) then return vec2(a.x//b.x,a.y//b.y) else return vec2(a.x//b,a.y//b) end end,
 __tostring=function(a)return "x: ".. a.x .."  y: ".. a.y end,
 __eq=function(a, b)if a.x==b.x and a.y==b.y then return true end end
}

function vec2(x,y)
 local v={x=x or 0,y=y or 0}
 setmetatable(v,meta)
 return v
end

function texrect(x1,y1,x2,y2,u1,v1,u2,v2,usemap,colorkey)
		usemap= usemap or false
		colorkey = colorkey or -1
  ttri(x1,y1,x1,y2,x2,y2,u1,v1,u1,v2,u2,v2,usemap,colorkey)
  ttri(x1,y1,x2,y1,x2,y2,u1,v1,u2,v1,u2,v2,usemap,colorkey)
end

function texrectvec2(pos1,pos2,uv1,uv2,usemap,colorkey)
 texrect(
  pos1.x,pos1.y,
  pos2.x,pos2.y,
  uv1.x,uv1.y,
  uv2.x,uv2.y,
  usemap,
  colorkey
 )
end

function rectvert(pos1,pos2,pos3,pos4,color)
	tri(
		pos1.x,pos1.y,
		pos2.x,pos2.y,
		pos3.x,pos3.y,
		color or 0
	)
	tri(
		pos2.x,pos2.y,
		pos3.x,pos3.y,
		pos4.x,pos4.y,
		color or 0
	)
end

function rectvec2(pos, size, color)
 rect(pos.x, pos.y, size.x, size.y, color)
end

function mapvec2(p, r, s, colk, sca, rema)
 map(p.x,p.y,r.x,r.y,s.x,s.y,colk,sca,rema)
end

system={
 init=function()end,
 reset=function()end,
 draw=function() layers:draw() end,
 update=function()end,
 debug=function() end,
}

layers={
 add=function(s, layer, item)
  if s[layer]==nil then s[layer]={} end
  table.insert(
   s[layer], 
   {
    id = item.id,
    draw = function(s) 
     item:draw() 
    end
   }
  )
 end,
 remove=function(s,layer,item)
  for k, i in ipairs(s[layer]) do
   if i.id==item.id then
    table.remove(s[layer], k)
   end
  end
 end,
 draw=function(s)
	 for k, i in ipairs(s) do
		 for k2, j in ipairs(i) do
			 j:draw()
			end
		end
	end
} 

function sprtex(spr, pos1, pos2, uv1, uv2,colorkey)
 local x=(spr%16)*8
 local y=(spr//16)*8
 texrectvec2(
  pos1,
  pos2,
  vec2(x,y)+uv1,
  vec2(x,y)+uv2,
  false,
  colorkey
 )
end

tasks={
 add=function(s, program)
  local task={}
   task.name=program.name
   task.t=0
   task.init=function() program:init() end
   task.update=function() program:update() task.t=task.t+1 end
  table.insert(s,task)
 end,
 stop_task=function(s,program)
  for k, ta in ipairs(s) do
   if ta==program then
    table.remove(s, k)
   end
  end
 end,
 update=function(s)
  for k, ta in ipairs(s) do
   ta.update()
  end
 end 
}

windows={
	add=function(s,program,pos,size)
		local w ={}
			w.name=program.name
			w.pos=pos or vec2(60,34)
			w.size=size or vec2(120,68)
			w.draw=function() program:draw end
		table.insert(s,w)
	end,
	init=function(s)
		for k, w in ipairs(s) do
			w.pos=pos or vec2(60,34)
			w.size=size or vec2(120,68)
			w.draw=function() program:draw end
		end
	end,
	draw=function()
	 
	end,
	update=function(s)
		for 
		if mouse_.pos.x>pos.y+size.x-8 and mouse_.pos.x<pos.y+size.x then
			if mouse_.pos.y>pos.y and mouse_.pos.y<pos.y+8 then
				if mouse_.l then
					tasks:stop_task(program)
				end
			end
		end
		if mouse_.pos.x>pos.y+size.x-16 and mouse_.pos.x<pos.y+size.x-8 then
			if mouse_.pos.y>pos.y and mouse_.pos.y<pos.y+8 then
				if mouse_.l then
					tasks:stop_task(program)
				end
			end
		end
		if mouse_.pos.x>pos.y+size.x-24 and mouse_.pos.x<pos.y+size.x-16 then
			if mouse_.pos.y>pos.y and mouse_.pos.y<pos.y+8 then
				if mouse_.l then
					program.status="minimized"
				end
			end
		end
	end
}
  
 if program.status~="minimized" then
		rectvec2(pos, size,15)
		rectvec2(pos, vec2(size.x,8), 12)
		sprtex(
		 255,
		 pos+vec2(size.x-8,0),
			vec2(8,8),
			vec2(0,0),
			vec2(8,8),
			12
		)
		sprtex(
		 254,
		 pos+vec2(size.x-16,0),
			vec2(8,8),
			vec2(0,0),
			vec2(8,8),
			12
		)
		sprtex(
		 253,
		 pos+vec2(size.x-24,0),
			vec2(8,8),
			vec2(0,0),
			vec2(8,8),
			12
		)
		print(program.name,pos.x+1,pos.y+1,12)
 end
end

function init()
 if System.t==0 or System.t<1 then
	 system:init()
	end
end

function draw()
 system:draw()
end

function update()
 system:update()
 System.t=System.t+1
end

mouse_={
 pos=vec2(0,0),
 l=false,
 m=false,
 r=false,
 sc=vec2(0,0),
 update=function(s)
  s.x,s.y,s.l,s.m,s.r,s.scx,s.scy=mouse()
 end
}

System={}
System.t=0
----------------------------------------------------------
--write the game code below

C={}

function new_program(program)
 local program={
  add=function(s,pos,size)
   local p={}
    p.name=program.name
    p.pos=pos or vec2(0,0)
    p.size=size or vec2(0,0)
    p.update=program.update
    p.draw=program.draw
    p.status="pop_up"
    
   table.insert(s,p)
  end,
  update=function(s)
   for k, i in ipairs(s) do
    i.update()
   end
  end,
  draw=function(s)
   for k, i in ipairs(s) do
    i.draw(i,i.pos,i.size)
   end
  end
 }
 return program
end

function system:init()
 local windowsBlack=new_program({
  name="black window",
  update=function(s) end,
  draw=function(s,pos,size)
   local pos=pos+vec2(0,8)
   local size=size+vec2(0,-8)
   rectvec2(pos,size,15)
  end,
 })
 windowsBlack:add(
  vec2(60,34),
  vec2(120,68)
 )
 tasks:add(windowsBlack)
 layers:add(1,{name="cls",draw=cls,id=0})
 layers:add(2,{name="programs",draw=function()window(windowsBlack)end,id=0})
end

function system:draw()
 layers:draw() 
end

function system:update()
 mouse_:update()
 tasks:update()
end

function TIC()
 init()
	update()
	draw()
end
-- <TILES>
-- 253:000000000000000000000000000000000ffffff0000000000000000000000000
-- 254:000000000ffffff00f0000f00f0000f00f0000f00f0000f00ffffff000000000
-- 255:000000000f0000f000f00f00000ff000000ff00000f00f000f0000f000000000
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
-- 001:101020481c4869182ca52c18ba9d30559920249561145955201c441c3889185da1309dc2aaaaaa7d8d9d5d6165182438
-- </PALETTE>

