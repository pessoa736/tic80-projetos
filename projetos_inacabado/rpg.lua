-- engine:         pudim engine 
-- author:         xpuddine
-- license:        MIT License
-- engine version: 0.4
-- script:         lua
-- [resumo]
-- rpg (991 linhas): RPG sobre a PudimEngine v0.4 (inacabado).
-- Engine embutida no mesmo arquivo (vec2, paleta, texrect, text_block...) + new_npc
-- e game:init / update / draw. Versão cart: projetos_inacabado/rpg/rpg.tic.
-- ------------------------------------------------------------

debug=nil

m=math

function m.maxvec2(v2_1,v2_2)
 return vec2(
 	m.max(v2_1.x,v2_2.x),
 	m.max(v2_1.y,v2_2.y)
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

function rotate(x,y,ax,ay)
	return
		(m.sin(x)*ax)+(m.cos(y)*ay),
		(m.cos(x)*ax)-(m.sin(y)*ay)
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

solid_check=function(p,cx,cy,s)
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

menu={init=function()end,reset=function()end,draw=function()end,update=function()end}
game={init=function()end,reset=function()end,draw=function()end,update=function()end}


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


function init()
 if Game.state == "game" then
  game:init()
 elseif Game.state == "menu" then
  menu:init()
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
end

Game={}
Game.state="game"
Game.old_state=game.state
Game.t=0
size=1
celltiles=8*size
----------------------------------------------------------
--write the game code below


skinsTB={
 [1]=function(pos,size)
  local i = 0 
  for x=pos.x,pos.x+size.x,8 do
   for y=pos.y,pos.y+size.y,8 do
    if i%2==0 then
     rect(x,y,8,8,13)
    else
     rect(x,y,8,8,14)
    end
    rect(pos.x+2,pos.y+2,size.x-4,size.y-4,12)
   i=i+1
   end
  end
  return vec2(4,4)
 end
}

plr={
 add=function(s,pos)
  local p={}
   p.pos=pos or vec2(0,0)
   p.vel=vec2(0,0)
   p.stop=false
   p.direction=0
   p.h=18
   p.w=16
   p.statusSpr=0
   p.t=0
   p.sprs={
    [0]={[0]=256,258},
    [1]={[0]=260,262,264,266,268,270},
    [2]={[0]=304,306}, 
    [3]={[0]=308,310},
    [4]={[0]=312,314}
   }
   
  table.insert(s,p)
 end,
 update=function(s)
  for k, s in ipairs(s) do
   local oldBtn=btn
   local function btn(n)
    if s.stop==false then 
     return oldBtn(n)
    else
     return false
    end
   end
   
   if btn(2) and not btn(3) then
    s.vel.x=-1
    s.direction=1
   elseif btn(3) and not btn(2) then 
    s.vel.x=1
    s.direction=0
   else
    s.vel.x=0
   end
   if btn(0) and not btn(1) then
    s.vel.y=-1 
    s.direction=2
   elseif btn(1) and not btn(0) then 
    s.vel.y=1
    s.direction=3
   else
    s.vel.y=0
   end
   if solid_check(s,celltiles,celltiles*2,1) or solid_check(s,celltiles*2.9,celltiles*3.2,1) then
    s.vel.x=0
    s.vel.y=0
   end  
   
   s.pos=s.pos+s.vel
   s.t=s.t+1
  end 
 end,
 draw=function(s)
  for k, s in ipairs(s) do  
   local pos = s.pos - map_.pos
   
   if (s.direction==2) then 
    if s.vel.y<0 then
     s.statusSpr=3
    else
     s.statusSpr=2
    end
   elseif (s.direction==3) then 
    if s.vel.y>0 then
     s.statusSpr=4
    else
     s.statusSpr=0
    end
   elseif (s.direction==0) or (s.direction==1) then 
    if s.vel.x~=0 then
     s.statusSpr=1
    else
     s.statusSpr=0
    end
   end
   
   local i=(s.t//(10))%(#s.sprs[s.statusSpr]+1)
   local spr_=s.sprs[s.statusSpr][i]
 
   if s.direction~=1 then
    sprtex(
     spr_,
	    pos+vec2(0,0),
	    pos+vec2(s.w,s.h),
	    vec2(0,0),
	    vec2(s.w,s.h),
					0
				)
	  elseif s.direction~=0 then
			 sprtex(
     spr_,
	    pos+vec2(s.w,0),
	    pos+vec2(0,s.h),
	    vec2(0,0),
	    vec2(s.w,s.h),
					0
				)		
			end
	 end 
 end,
}


map_={
 pos=vec2(0,0),
 draw=function(m)
		map(
			(m.pos.x)/celltiles,(m.pos.y)/celltiles,
			32,19,
			-celltiles-m.pos.x%celltiles,-celltiles-m.pos.y%celltiles,
			nil,
			size
		)
			
	end,
	camera_follow = function(s,t)
	 for k, target in ipairs(t) do
	  s.pos=lerp_vec2(
			 s.pos,
				m.maxvec2(vec2(0,0),target.pos-vec2(112,60)),
				vec2(0.5,0.5)
			)
  end
	end 
}


function new_npc(sprs, size, uv, additional_variables)
 local npc={
  add = function (s, pos)
   local n=additional_variables or {}
    n.pos=pos or vec2(0,0)
    n.vel=vec2(0,0)
    n.h=size.y
    n.w=size.x
    n.direction=0
    n.statusSpr=0
    n.sprs=sprs
    n.t=0
   
   table.insert(s,n)
  end,
  update = function (s, function_)
   for k, n in ipairs(s) do
    local funct=function_ or function() end
    funct(n)
    
    n.pos=n.pos+n.vel
    n.t=n.t+1
   end
  end,
  draw = function (s)
   for k, n in ipairs(s) do
     local pos = n.pos - map_.pos
   
		   if (n.direction==2) then 
		    if n.vel.y<0 then n.statusSpr=3 else n.statusSpr=2 end
		   elseif (n.direction==3) then 
		    if n.vel.y>0 then n.statusSpr=4 else n.statusSpr=0 end
		   elseif (n.direction==0) or (n.direction==1) then 
		    if n.vel.x~=0 then n.statusSpr=1 else n.statusSpr=0 end
		   end
		   
		   local i=(n.t//(10))%(#n.sprs[n.statusSpr]+1)
		   local spr_=n.sprs[n.statusSpr][i]
		 
		   if n.direction~=1 then
		    sprtex(
		     spr_,
			    pos+vec2(0,0),
			    pos+vec2(n.w,n.h),
			    vec2(0,0),
			    uv,
							0
						)
			  elseif s.direction~=0 then
					 sprtex(
		     spr_,
			    pos+vec2(n.w,0),
			    pos+vec2(0,n.h),
			    vec2(0,0),
			    uv,
							0
						)
					end
   end
  end
 }
 
 return npc
end

function game:init()
 test=new_npc(
  {[0]={[0]=480},[1]={[0]=480},[2]={[0]=480},[3]={[0]=480}},
  vec2(16,16),
  vec2(16,16),
  {read=false,initText=false}
 )
 plr:add(vec2(120,68))
 test:add(vec2(120,32))
 
 layers:add(function() map_:draw() end,1)
 layers:add(function() test:draw() end,2)
 layers:add(function() plr:draw() end,3)
 layers:add(function() for i=-1,1 do
	  for j=-1,1 do
	   print("aperte 'z' para interagir com as coisas",2+i,128+j)
	  end
	 end
	 print("aperte 'z' para interagir com as coisas",2,136-8,12)
 end,4)
 
 layers:add(function() text_block:draw() end, 5)
end

function game:update()
 map_:camera_follow(plr)
 plr:update()
 test:update(
  function(s)
   for k, plr in ipairs(plr) do
    local  endtext = text_block:write(1,"mais coisinhas em breve")
    if m.abs(plr.pos.x-s.pos.x)<=s.w then
     if m.abs(plr.pos.y-s.pos.y)<=s.h  then
	     if btnp(4,0,-1) and s.initText==false then
						 s.initText=true
							plr.stop=true
					  text_block:add(1,1/4,vec2(0,104),vec2(240,32),skinsTB[1])
					 end
     end
    end
    if endtext==true and btnp(4,0,-1)then
	    text_block:remove(1)
					s.initText=false
					plr.stop=false
    end
   end
  end
 )
end

function game:draw()
 layers:draw()
 
end

init()
function TIC()
	update()
	cls()
	draw()
end

-- <TILES>
-- 001:5555555555555555555555555555555555555555555555555555555555555555
-- 002:dccddccddccddccddccddccddccddccddccddccddccddccddccddccddccddccd
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
-- 016:ceeeeeeeceeeeeeedeeeeeeedeeeeeeeceeeeeeeceeeeeeedeeeeeeedeeeeeee
-- 017:eeeeeeedeeeeeeedeeeeeeeceeeeeeeceeeeeeedeeeeeeedeeeeeeeceeeeeeec
-- 018:dccddccddccddccddccddccddccddccddccddccddccddccdeddeeddeffffffff
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
-- 032:ddccddcceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 033:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 034:5555555555555555555555555555555555555555555555555555555555555555
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
-- 128:5555555556555555565556555555565555655555556555555555555655555556
-- 129:5555555555555555555555555555556555555565555555555655555556555555
-- 130:5555555555565555555655555555555555555555555555555555555555555555
-- 131:feeefeeefeeefffffeeefeeefeeefeeefeeefeeefffffeeefeeefeeefeeefeee
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

-- <SPRITES>
-- 000:000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfcccccccffcccccd
-- 001:ffffff00eeeccf00cccccf00cccdcf00cccdcf00cccdcf00cccccf00ddcccf00
-- 002:000000000000ffff00fffcce0ffccccc0fcccccd0fccfccd0fccfccd0fcccccc
-- 003:00000000fffffff0eeeeccf0ccccccf0ccccdcf0ccccdcf0ccccdcf0ccccccf0
-- 004:00000000000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfccccccc
-- 005:00000000ffffff00eeeccf00cccccf00cccdcf00cccdcf00cccdcf00cccccf00
-- 006:000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfcccccccffcccccd
-- 007:ffffff00eeeccf00cccccf00cccdcf00cccdcf00cccdcf00cccccf00ddcccf00
-- 008:000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfcccccccffcccccd
-- 009:ffffff00eeeccf00cccccf00cccdcf00cccdcf00cccdcf00cccccf00ddcccf00
-- 010:000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfcccccccffcccccd
-- 011:ffffff00eeeccf00cccccf00cccdcf00cccdcf00cccdcf00cccccf00ddcccf00
-- 012:000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfcccccccffcccccd
-- 013:ffffff00eeeccf00cccccf00cccdcf00cccdcf00cccdcf00cccccf00ddcccf00
-- 014:000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfcccccccffcccccd
-- 015:ffffff00eeeccf00cccccf00cccdcf00cccdcf00cccdcf00cccccf00ddcccf00
-- 016:0ffffccc0000fdde0fffdddeffccddfefccccfeefccccfeeffccfeee0ffffeef
-- 017:ccccff00eeedfff0eeedccffeeeccccfeeeccccfee7fccfff77ffff0f77ff000
-- 018:0ffccccc00ffffcc0000fdde0fffdddeffccddfefccccfeefccccfeeffccfeee
-- 019:dddcccf0cccccff0eeedfff0eeedccffeeeccccfeeeccccfee7fccfff77ffff0
-- 020:ffcccccd0ffffccc0000fdde0fffdddeffccddfefccccfeefccccfeeffccfeee
-- 021:ddcccf00ccccff00eeedfff0eeedccffeeeccccfeeeccccfee7fccfff77ffff0
-- 022:0ffffccc000ffdde00ffddde0ffccdfe0fccccfe0fccccfe00fcc77f000ff777
-- 023:ccccff00eeedff00eeeddf00eeeccff0eeccccf0eeccccf0eeeccff0feefff00
-- 024:0ffffccc0000fdde0000fdde000ffcce000fcccc000fcccc000ffcce0000f77f
-- 025:ccccff00eeedf000eeedf000eeecff00eeeccf00ee7ccf00eefcff00eefff000
-- 026:0ffffccc0000fdde0000fddd0000ffdc00000fcc0000ffcc0000feec0000feee
-- 027:ccccff00eeedf000eeedf000ceeff000ccef0000ccef0000ce7f0000f77ff000
-- 028:0ffffccc0000fdde0000fdde000ffcce000fcccc000fcccc000ffcce00000fee
-- 029:ccccff00eeedf000eeedf000eeecff00eeeccf00ee7ccf00e77cff00f77fff00
-- 030:0ffffccc000ffdde00ffddde0ffccdfe0fccccfe0fccccfe00fcceee000ffeee
-- 031:ccccff00eeedff00eeeddf00eeeccff0eeccccf0eeccccf0ee7ccff0f77fff00
-- 032:0000feee0000ffff000000000000000000000000000000000000000000000000
-- 033:f777f000fffff000000000000000000000000000000000000000000000000000
-- 034:0ffffeee0000ffff000000000000000000000000000000000000000000000000
-- 035:f777f000fffff000000000000000000000000000000000000000000000000000
-- 036:0ffffeee0000ffff000000000000000000000000000000000000000000000000
-- 037:f777f000fffff000000000000000000000000000000000000000000000000000
-- 038:0000f7ff0000fff0000000000000000000000000000000000000000000000000
-- 039:feeef000fffff000000000000000000000000000000000000000000000000000
-- 040:0000ff7f00000fff000000000000000000000000000000000000000000000000
-- 041:eeef0000ffff0000000000000000000000000000000000000000000000000000
-- 042:0000feff0000fff0000000000000000000000000000000000000000000000000
-- 043:f777f000fffff000000000000000000000000000000000000000000000000000
-- 044:00000ffe000000ff000000000000000000000000000000000000000000000000
-- 045:f777f000fffff000000000000000000000000000000000000000000000000000
-- 046:0000feff0000fff0000000000000000000000000000000000000000000000000
-- 047:f777f000fffff000000000000000000000000000000000000000000000000000
-- 048:00ffffff00fcceee00fccccc00fccccc00fccccc00fccccc00fccccc00fccccc
-- 049:fffff000eeccfff0ccccccffcccccccfccccfccfccccfccfcccccccfccccccff
-- 050:000000000fffffff0fcceeee0fcccccc0fcccccc0fcccccc0fcccccc0fcccccc
-- 051:00000000ffff0000eccfff00cccccff0ccccccf0cccfccf0cccfccf0ccccccf0
-- 052:00ffffff00fcceee00fccccc00fccccc00fccccc00fccccc00fccccc00fccccc
-- 053:fffff000eeccfff0ccccccffcccccccfccccfccfccccfccfcccccccfccccccff
-- 054:00ffffff00fcceee00fccccc00fccccc00fccccc00fccccc00fccccc00fccccc
-- 055:fffff000eeccfff0ccccccffcccccccfccccfccfccccfccfcccccccfccccccff
-- 056:000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfcccccccffcccccd
-- 057:ffffff00eeeccf00cccccf00ccdccf00ccdccf00ccdccf00cccccf00ddcccf00
-- 058:000fffff0fffcceeffccccccfcccccdcfccfccdcfccfccdcfcccccccffcccccd
-- 059:ffffff00eeeccf00cccccf00ccdccf00ccdccf00ccdccf00cccccf00ddcccf00
-- 064:00ffcccc00ffdeee0ffddeeeffccdeeefcccceeefcccc7eeffccf77f0ffff77f
-- 065:cccffff0eedff000eeddff00eedccff0eeccccf0eeccccf0eefccff0eeffff00
-- 066:0fcccccc0ffccccc00ffdeee0ffddeeeffccdeeefcccceeefcccc7eeffccf77f
-- 067:cccccff0ccffff00eedff000eeddff00eedccff0eeccccf0eeccccf0eefccff0
-- 068:00ffcccc000ffdee000fddee00fccdee00fcccee00fccc7e000fff770000f777
-- 069:ccccfff0eeedff00eeeddff0eeedccffeeeccccfeeeccccffeecccfffeeffff0
-- 070:00ffcccc000ffdee00ffddee0ffccdee0fccccee0fcccc7e0ffccc7700ffff77
-- 071:ccccfff0eeedff00eeeddf00eeedccf0eeecccf0eeecccf0feefff00feeef000
-- 072:0ffffccc000ffdee00ffddee0ffccdee0fccccee0fccccee0ffcccee00ffffee
-- 073:ccccff00eeedff00eeeddff0eeedccf0eeecccf0ee7cccf0f77ffff0f777f000
-- 074:0ffffccc000ffdee000fddee00fccdee00fcccee00fcccee00ffffee0000feee
-- 075:ccccff00eeedff00eeeddff0eeedccffeeeccccfee7ccccff77cccfff77ffff0
-- 080:000ff77f000fffff000000000000000000000000000000000000000000000000
-- 081:eeff0000ffff0000000000000000000000000000000000000000000000000000
-- 082:0ffff77f000fffff000000000000000000000000000000000000000000000000
-- 083:eeffff00ffff0000000000000000000000000000000000000000000000000000
-- 084:0000f7770000ffff000000000000000000000000000000000000000000000000
-- 085:ffff0000f0000000000000000000000000000000000000000000000000000000
-- 086:00000fff00000000000000000000000000000000000000000000000000000000
-- 087:feeef000fffff000000000000000000000000000000000000000000000000000
-- 088:00000fff00000000000000000000000000000000000000000000000000000000
-- 089:f777f000fffff000000000000000000000000000000000000000000000000000
-- 090:0000feee0000ffff000000000000000000000000000000000000000000000000
-- 091:ffff0000f0000000000000000000000000000000000000000000000000000000
-- 224:000000cc000000cf0ccccccc0cffffff0cfddddd0cfdeedd0cfdedde0cfddddd
-- 225:cc000000fc000000ccccccc0ffffffc0dddddfc0dddedfc0eddddfc0ddeedfc0
-- 240:0cfddddd0cffffff0ccccccc000000cf000000cf000000cf000000cf000000cc
-- 241:dddddfc0ffffffc0ccccccc0fc000000fc000000fc000000fc000000cc000000
-- </SPRITES>

-- <MAP>
-- 001:000011202020202020202020202020202020202020202020202020202020200100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:000011212121212121212121212121212121212121212121212121212121210100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:000011383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:000011383838383838383838383838383838383838383838383838383838382020202020200100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:000011383838383838383838383838383838383838383838383838383838382121212121210100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:000011383838383838383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:000011383838383838383838383838383838383838383838383838383838380202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 017:000011383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:000011383838383838383838383838383838383838383838383838383838380100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:000012020202020202020202023838383838383838383838020202020202021200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:000000000000000000000000113838383838383838383838010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 021:000000000000000000000000113838383838383838383838010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:000000000000000000000000113838383838383838383838010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:000000000000000000000000113838383838383838383838010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:000000000000000000000000113838383838383838383838010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:000000000000000000000000000202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

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
-- 000:10202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202000200040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
-- </FLAGS>

-- <PALETTE>
-- 000:1c1c0c6d4c55d68553ffa157f6ce75ceda70b2ba646169654c55694459897185c691aeeeffe2ce948d656c563c3c3420
-- </PALETTE>

