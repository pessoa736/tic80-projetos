-- engine:         pudim engine
-- author:         xpuddine
-- license:        MIT License
-- engine version: 0.5
-- script:         lua
-- [resumo]
-- PudimEngine v0.5: minha engine para TIC-80.
-- vec2, manipulação de paleta (PAL, pal, reset_pal), texturas em retângulos
-- rotacionáveis (texrect via ttri), rotatespr, efeito glitch (SCN), text_block
-- (caixas de texto), mapvec2/sprtex, e o ciclo init/update/draw/TIC.
-- ------------------------------------------------------------

m=math

function m.maxvec2(v2_1,v2_2)
 return vec2(
 	m.max(v2_1.x,v2_2.x),
 	m.max(v2_1.y,v2_2.y)
 )
end
function m.minvec2(v2_1,v2_2)
 return vec2(
 	m.min(v2_1.x,v2_2.x),
 	m.min(v2_1.y,v2_2.y)
 )
end

PAL={}
addr=0x03fc0
for i=0,15 do
 for j=0,2 do
  PAL[i+j]=peek(addr+(i*3)+j)
 end
end

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

function reset_pal()
	for i=0x03fc0,0x03fc0+47 do
	 poke(i,PAL[i])
	end
end

function pal(i,r,g,b,luminosity)
	--sanity checks
	if i<0 then i=0 end
	if i>15 then i=15 end
	--returning color r,g,b of the color
	if r==nil and g==nil and b==nil and luminosity==nil then
		return peek(0x3fc0+(i*3)),peek(0x3fc0+(i*3)+1),peek(0x3fc0+(i*3)+2)
	else
		if r==nil or r<0 then r=0 end
		if g==nil or g<0 then g=0 end
		if b==nil or b<0 then b=0 end
		if luminosity==nil or luminosity<0 then luminosity=0 end

		if luminosity>255 then luminosity=255 end
		if r>255 then r=255 end
		if g>255 then g=255 end
		if b>255 then b=255 end
		poke(0x3fc0+(i*3)+2,b-luminosity)
		poke(0x3fc0+(i*3)+1,g-luminosity)
		poke(0x3fc0+(i*3),r-luminosity)
	end
end

pal(0,44,44,26)
pal(1,109,76,85)
pal(2,214,133,83)
pal(3,255,161,87)
pal(4,246,206,117)
pal(5,206,218,112)
pal(6,178,186,100)
pal(7,97,105,101)
pal(8,76,85,105)
pal(9,68,89,137)
pal(10,113,133,198)
pal(11,145,174,238)
pal(12,255,226,206)
pal(13,148,141,101)
pal(14,108,86,60)
pal(15,60,40,20)

function printRainbow(text,x,y)
	for i=0,#text	do
  print(text:sub(i,i),(i*6)+x,y,i)
 end
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


function rotatespr(a,r,pos,uv1,uv2,colorkey)
 local pi=math.pi

 local p1=rotate(a-pi,r.x,r.y)
 local p2=rotate(a+pi/2,r.x,r.y)
 local p3=rotate(a,r.x,r.y)
 local p4=rotate(a-pi/2,r.x,r.y)

 texrect(
  pos.x, pos.y,
  p2,
  p4,
  p3,
  p1,

  uv1.x,uv1.y,
  uv2.x,uv2.y,

  false,
  colorkey
 )

end

function sget(pos)
 local addr=0x4000+(pos.x//8+pos.y//8*16)*32 -- get sprite address
 return peek4(addr*2+pos.x%8+pos.y%8*8) -- get sprite pixel
end

local shake=0
function glitch(action, d, time)
  -- 'Change screen offset in every scanline' demo
  -- created by: Vadim
  -- modified by: xpudding

	if action==true then shake=60*time end
	if shake>0 then
		poke(0x3FF9+1,math.random(-d,d))
		shake=shake-1
		if shake==0 then memset(0x3FF9,0,2) end
	end

	function SCN(row)
		if shake>0 then
			poke(0x3FF9,math.random(-d,d))
		end
	end
end

function rotate(a,rx,ry)
	return
		(m.sin(a)*rx)+(m.cos(a)*ry),
		(m.cos(a)*rx)-(m.sin(a)*ry)
end

function lerp(a,b,t)
	return a*(1-t)+b*t
end

function lerp_vec2(a,b,t)
	return
	 vec2(
		 lerp(a.x,b.x,t.x),
		 lerp(a.y,b.y,t.y)
		)
end

function rectvec2(pos, size, color)
 rect(pos.x, pos.y, size.x, size.y, color)
end

text_block={}
function text_block:add(id,spd,pos,size,skin)
 local tb={}
  tb.text=""
  tb.function_draw=skin or function(p,s) rectvec2(p,s,12) return vec2(0,0) end
  tb.pos=pos or vec2(0,0)
  tb.size=size or vec2(0,0)
  tb.t=0
  tb.spd=spd or 1/10

 text_block[id]=tb
end

function text_block:remove(id)
 text_block[id]=nil
end

function text_block:write(id, text)
 if text_block[id]~=nil then
  text_block[id].text=text
  return text_block[id].t>#text_block[id].text
 end
end

function text_block:draw()
 for k, s in ipairs(text_block) do
	 local postext=s.function_draw(s.pos, s.size)

  local text2=s.text:sub(0,s.t//1)
  print(
    text2,
    s.pos.x+postext.x+2,
    s.pos.y+postext.y+2,
    3
   )
  s.t=s.t+s.spd
 end
end

collision_check=function(p,cx,cy,s)
  local pos=p.pos or vec2(0,0)
  local vel=p.vel or vec2(0,0)
  local acel=p.acel or vec2(0,0)
	 local x=pos.x+vel.x+cx+acel.x
	 local y=pos.y+vel.y+cy+acel.y
		return fget(mget(x//celltiles,y//celltiles),s)
end

function mapvec2(p, r, s, colk, sca, rema)
 map(p.x,p.y,r.x,r.y,s.x,s.y,colk,sca,rema)
end

menu={
 init=function()end,
 reset=function()end,
 draw=function() layers:draw() end,
 update=function()end
}
game={
 init=function()end,
 reset=function()end,
 draw=function() layers:draw() end,
 update=function()end
}


layers={
 add=function(s,funct_draw,layer)
  s[layer]=funct_draw
 end,
 remove=function(l,layer)
  for k,s in ipairs(l) do
   if s==l[layer] then
    s=nil
   end
  end
 end,
 sort=function(l,funct_draw,layer)
  local removal_check=false
  for k,s in ipairs(l) do
   if s==funct_draw then
    l:remove(funct_draw,k)
    removal_check=true
   end
   if removal_check==true then
    l:add(funct_draw,layer)
   end
  end
 end,
 draw=function(l)
	 for k,s in ipairs(l) do
		 local funct=s
			if funct~=nil then
			 funct()
			end
	 end
 end,
	clear=function(l)
		for k, lay in ipairs(l) do
			l[k]=nil
		end
	end,
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

function hide_mouse()
	poke(0x03ffb,0)
end

function init()
 if Game.t==0 or Game.t<1 then
	 if Game.state == "game" then
	  game:init()
	 elseif Game.state == "menu" then
	  menu:init()
	 end
	end
end
function draw()
 if Game.state == "game" then
  game:draw()
 elseif Game.state == "menu" then
  menu:draw()
 end
end
function update()
 if Game.state == "game" then
  game:update()
 elseif Game.state == "menu" then
  menu:update()
 end
 Game.t=Game.t+1
end

Game={}
Game.state="game"
Game.old_state=game.state
Game.t=0
size=1
celltiles=8*size
----------------------------------------------------------
--write the game code below

function TIC()
 init()
	update()
	draw()
end

-- <TILES>
-- 001:5555555555555555555555555555555555555555555555555555555555555555
-- 002:5555555555555555555555555555555555555555555555555555555555555555
-- 003:5555555555555555555555555555555555555555555555555555555555555555
-- 004:5555555555555555555555555555555555555555555555555555555555555555
-- 005:5555555555555555555555555555555555555555555555555555555555555555
-- 006:5555555555555555555555555555555555555555555555555555555555555555
-- 007:5555555555555555555555555555555555555555555555555555555555555555
-- 008:5555555555555555555555555555555555555555555555555555555555555555
-- 009:5555555555555555555555555555555555555555555555555555555555555555
-- 010:5555555555555555555555555555555555555555555555555555555555555555
-- 011:5555555555555555555555555555555555555555555555555555555555555555
-- 012:5555555555555555555555555555555555555555555555555555555555555555
-- 013:5555555555555555555555555555555555555555555555555555555555555555
-- 014:5555555555555555555555555555555555555555555555555555555555555555
-- 015:5555555555555555555555555555555555555555555555555555555555555555
-- 016:5555555555555555555555555555555555555555555555555555555555555555
-- 017:5555555555555555555555555555555555555555555555555555555555555555
-- 018:5555555555555555555555555555555555555555555555555555555555555555
-- 019:5555555555555555555555555555555555555555555555555555555555555555
-- 020:5555555555555555555555555555555555555555555555555555555555555555
-- 021:5555555555555555555555555555555555555555555555555555555555555555
-- 022:5555555555555555555555555555555555555555555555555555555555555555
-- 023:5555555555555555555555555555555555555555555555555555555555555555
-- 024:5555555555555555555555555555555555555555555555555555555555555555
-- 025:5555555555555555555555555555555555555555555555555555555555555555
-- 026:5555555555555555555555555555555555555555555555555555555555555555
-- 027:5555555555555555555555555555555555555555555555555555555555555555
-- 028:5555555555555555555555555555555555555555555555555555555555555555
-- 029:5555555555555555555555555555555555555555555555555555555555555555
-- 030:5555555555555555555555555555555555555555555555555555555555555555
-- 031:5555555555555555555555555555555555555555555555555555555555555555
-- 032:5555555555555555555555555555555555555555555555555555555555555555
-- 033:5555555555555555555555555555555555555555555555555555555555555555
-- 034:5555555555555555555555555555555555555555555555555555555555555550
-- 035:5555555555555555555555555555555555555555555555555555555505555555
-- 036:5555555555555555555555555555555555555555555555555555555555555555
-- 037:5555555555555555555555555555555555555555555555555555555555500555
-- 038:5555555555555555555555555555555555555555555555555555555555555055
-- 039:5555555555555555555555555555555555555555555555555555555555555555
-- 040:5555555555000555555555555555555555555555555555555555555555055555
-- 041:5555555555555555555000005550555555505555555055555550055555550555
-- 042:5555555555555555005555555005555555505555555505555555055555550555
-- 043:5555555555555555555555555555555555555555555555555555555555555555
-- 044:5555555555555555555555555555555555555555555555555555555555555555
-- 045:5555555555555555555555555555555555555555555555555555555555555555
-- 046:5555555555555555555555555555555555555555555555555555555555555555
-- 047:5555555555555555555555555555555555555555555555555555555555555555
-- 048:5555555555555555555555555555555555555555555555555555555555555555
-- 049:5555555555555555555555555555555555555555555555555555555555555555
-- 050:5555550555555505555555055555550055555555555555555555555555555555
-- 051:5555555555555555555555550055555555000005555555505555555555555550
-- 052:5555555555555550555555505555550055555505055555050555550505555505
-- 053:5505005555555005555555055555550055555550555555505555555055555550
-- 054:5555505555555055555550055555550555555505555555055555505555555055
-- 055:5555555555555555555555555555555555555555555555555555555555555555
-- 056:5505555555055555550555555505555555055555550555555505555555055555
-- 057:5555055555550555555505555555055555550550550000055555555555555555
-- 058:5555055555500555555055555505555500555555555555555555555555555555
-- 059:5555555555555555555555555555555555555555555555555555555555555555
-- 060:5555555555555555555555555555555555555555555555555555555555555555
-- 061:5555555555555555555555555555555555555555555555555555555555555555
-- 062:5555555555555555555555555555555555555555555555555555555555555555
-- 063:5555555555555555555555555555555555555555555555555555555555555555
-- 064:5555555555555555555555555555555555555555555555555555555555555555
-- 065:5555555555555555555555555555555555555555555555555555555555555555
-- 066:5555555555555555555555505555555555555555555555555555555555555555
-- 067:5555500555500055000055555555555555555555555555555555555555555555
-- 068:5555550055555550555555555555555555555555555555555555555555555555
-- 069:5555550000555505500000555555555555555555555555555555555555555555
-- 070:5555505555555055555550555555500055555005555555555555555555555555
-- 071:5555555555555555555555550005555555555555555555555555555555555555
-- 072:5505555555055555555555555555555555555555555555555555555555555555
-- 073:5555555555555555555555555555555555555555555555555555555555555555
-- 074:5555555555555555555555555555555555555555555555555555555555555555
-- 075:5555555555555555555555555555555555555555555555555555555555555555
-- 076:5555555555555555555555555555555555555555555555555555555555555555
-- 077:5555555555555555555555555555555555555555555555555555555555555555
-- 078:5555555555555555555555555555555555555555555555555555555555555555
-- 079:5555555555555555555555555555555555555555555555555555555555555555
-- 080:5555555555555555555555555555555555555555555555555555555555555555
-- 081:5555555555555555555555555555555555555555555555555555555555555555
-- 082:5555555555555555555555555555555555555555555555555555555555555555
-- 083:5555555555555555555555555555555555555555555555555555555555555555
-- 084:5555555555555555555555555555555555555555555555555555555555555555
-- 085:5555555555555555555555555555555555555555555555555555555555555555
-- 086:5555555555555555555555555555555555555555555555555555555555555555
-- 087:5555555555555555555555555555555555555555555555555555555555555555
-- 088:5555555555555555555555555555555555555555555555555555555555555555
-- 089:5555555555555555555555555555555555555555555555555555555555555555
-- 090:5555555555555555555555555555555555555555555555555555555555555555
-- 091:5555555555555555555555555555555555555555555555555555555555555555
-- 092:5555555555555555555555555555555555555555555555555555555555555555
-- 093:5555555555555555555555555555555555555555555555555555555555555555
-- 094:5555555555555555555555555555555555555555555555555555555555555555
-- 095:5555555555555555555555555555555555555555555555555555555555555555
-- 096:5555555555555555555555555555555555555555555555555555555555555555
-- 097:5555555555555555555555555555555555555555555555555555555555555555
-- 098:5555555555555555555555555555555555555555555555555555555555555555
-- 099:5555555555555555555555555555555555555555555555555555555555555555
-- 100:5555555555555555555555555555555555555555555555555555555555555555
-- 101:5555555555555555555555555555555555555555555555555555555555555555
-- 102:5555555555555555555555555555555555555555555555555555555555555555
-- 103:5555555555555555555555555555555555555555555555555555555555555555
-- 104:5555555555555555555555555555555555555555555555555555555555555555
-- 105:5555555555555555555555555555555555555555555555555555555555555555
-- 106:5555555555555555555555555555555555555555555555555555555555555555
-- 107:5555555555555555555555555555555555555555555555555555555555555555
-- 108:5555555555555555555555555555555555555555555555555555555555555555
-- 109:5555555555555555555555555555555555555555555555555555555555555555
-- 110:5555555555555555555555555555555555555555555555555555555555555555
-- 111:5555555555555555555555555555555555555555555555555555555555555555
-- 112:5555555555555555555555555555555555555555555555555555555555555555
-- 113:5555555555555555555555555555555555555555555555555555555555555555
-- 114:5555555555555555555555555555555555555555555555555555555555555555
-- 115:5555555555555555555555555555555555555555555555555555555555555555
-- 116:5555555555555555555555555555555555555555555555555555555555555555
-- 117:5555555555555555555555555555555555555555555555555555555555555555
-- 118:5555555555555555555555555555555555555555555555555555555555555555
-- 119:5555555555555555555555555555555555555555555555555555555555555555
-- 120:5555555555555555555555555555555555555555555555555555555555555555
-- 121:5555555555555555555555555555555555555555555555555555555555555555
-- 122:5555555555555555555555555555555555555555555555555555555555555555
-- 123:5555555555555555555555555555555555555555555555555555555555555555
-- 124:5555555555555555555555555555555555555555555555555555555555555555
-- 125:5555555555555555555555555555555555555555555555555555555555555555
-- 126:5555555555555555555555555555555555555555555555555555555555555555
-- 127:5555555555555555555555555555555555555555555555555555555555555555
-- 128:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 129:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 130:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 131:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 132:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 133:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 134:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 135:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 136:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 137:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 138:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 139:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 140:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 141:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 142:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 143:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 144:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 145:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 146:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 147:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 148:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 149:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 150:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 151:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 152:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 153:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 154:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 155:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 156:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 157:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 158:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 159:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 160:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 161:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 162:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 163:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 164:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 165:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 166:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 167:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 168:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 169:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 170:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 171:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 172:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 173:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 174:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 175:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 176:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 177:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
-- 178:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000bbbb
-- 179:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbb00bbbbbb00bbbb
-- 180:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0
-- 181:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000bbbbb0bbbbbbb
-- 182:bbbbbbbbbbbbbbbbbbbbbbbb0bbbbbbb0bbbbbbbb0bbbbbbb0bbbbb0b0bbb00b
-- 183:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbb00b00bbb0bb0bbb0bbbbbbb0bbb
-- 184:bbbbbbbbbbbbbbbbbbbbbbbb00000bbbbbbbbbbbbbbbbbbbbbbbbbbbb0000bbb
-- 185:bbbbbbbbb00000bbb0bbb000b0bbbbbbb0bbbbbbb0bbbbbbb0bbbbbbb0bbbbbb
-- 186:bbbbbbbbbbbbbbbbbbbbbbbb0bbbbbb00bbbbbb00bbbbbb00bbbbbb00bbbbbb0
-- 187:bbbbbbbbbbbbbbbb00bbbbbbbb000bbbbbbb0bbbbbbb00bbbbbbb00bbbbbbb0b
-- 188:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbbb0bbbbbbb0bbbbbbb0bbb
-- 189:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbbb0bbbbbbb0bbbb
-- 190:bb0bbb0bbb00bb0bbb00bb0bbb0b0b0bb00b0b0bb0bb0b0bb0bbb00bb0bbb00b
-- 191:b00000bbbb0bb000bb0bbbb0bb0bbbb0bb0bbbb0bb0bbbb0bb0bbbb0bb0bbbb0
-- 192:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 193:bbbb00bbbbbb0bbbbbbb0bbbbbbb0bbbbbbb0bbbbbbb0bbbbbbb00bbbbbbb0bb
-- 194:bbb00bbbbbbb0bbbbbbb0bbbbbb00bbb00000bbbbbbb00bbbbbbb0bbbbbbb0bb
-- 195:bb0b0bbbbb0b0bbbbb0b00bbb0bbb00bb0000000b0bbbbb0b0bbbbbbb0bbbbbb
-- 196:bbbbbb00bbbbbb0bbbbbbb0bbbbbb0bbbbbbb0bb0bbbb00b0bbbbb0000bbbbbb
-- 197:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbb00000000b
-- 198:b00000bbb0000bbbbb0b00bbbb0bb00bbb00bbb0bbb0bbbbbbb0bbbbbbb0bbbb
-- 199:bbbb00bbbbbbb0bbbbbbb0bbbbbbbb0bbbbbbb00bbbbbbbbbbbbbbbbbbbbbbbb
-- 200:bbb0bbbbbbb0bbbbbbb0bbbbbbb0bbbb0bb0bbb00000bbb0bbbbbbbbbbbbbbbb
-- 201:0bbbbbb0000000000bbb00bb0bbbbb000bbbbbb0bbbbbbb0bbbbbbbbbbbbbbbb
-- 202:0bbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbbbbbbbbbbb
-- 203:bbbbbb000bbbbbb00bbbbbb000bbbbb0b00bbb0bbb00b00bbbb000bbbbbbbbbb
-- 204:bbbb0bbbbbbb0bbbbbbbb0bbbbbbb00bbbbbbb00bbbbbbbbbbbbbbbbbbbbbbbb
-- 205:bbb0bbbbbbb0bbbbbbb0bbbbbbb0bbbb0000bbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 206:b0bbb00bb0bbb00bb0bbbb0bb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 207:bb0bbbb0bb0bb000bb000000b000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 208:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 209:bbbbb0bbbbbb0000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 210:bbbb00bb00000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 211:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 212:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 213:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 214:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 215:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 216:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 217:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 218:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 219:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 220:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 221:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 222:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 223:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 224:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 225:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 226:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 227:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 228:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 229:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 230:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 231:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 232:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 233:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 234:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 235:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 236:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 237:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 238:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 239:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 240:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 241:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 242:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 243:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 244:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 245:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 246:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 247:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 248:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 249:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 250:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 251:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 252:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 253:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 254:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 255:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
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

-- <FLAGS>
-- 000:10202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020204040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
-- </FLAGS>

-- <PALETTE>
-- 000:2c2c1a6d4c55d68553ffa157f6ce75ceda70b2ba646169654c55694459897185c691aeeeffe2ce948d656c563c3c2814
-- </PALETTE>

