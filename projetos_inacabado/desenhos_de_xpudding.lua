-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua
-- [resumo]
-- desenhos_de_xpudding (versão em um arquivo): galeria interativa dos meus desenhos.
-- Câmera com movimento, fotos (photo), partículas, shader estilo Game Boy (OVR).
-- Nota: package.path aponta para C:/Users/fenan/AppData/... (Windows antigo).
-- ------------------------------------------------------------

package.path = package.path .. "C:/Users/fenan/AppData/Roaming/com.nesbox.tic/TIC-80/projetos/desenhos_de_xpudding/?.lua"

require "desenhos"

cell = 8
zoom = 1

function pal(c0,c1)
	if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i)end
	else poke4(0x3FF0*2+c0,c1)end
end

ctrl = nil
function aim()
 if ctrl~=true and keyp(63,-1,-1) then
  ctrl=true
 elseif ctrl~=false and keyp(63,-1,-1) then
  ctrl=false
 elseif ctrl==nil then
  ctrl = false
 end
 
 if ctrl then 
	 pal = {[0]=15,[12]=13,[13]=14,[14]=15,[15]=0}
	 for i = 0, 240 do
	   pix(i, 68-1, pal[pix(i,68-1)])
	   pix(i, 68, pal[pix(i,68)])
	   pix(i, 68+1, pal[pix(i,68+1)])
	 end
	 for i = 0, 136 do
	  if  i ~= 67 and  i ~= 68 and  i ~= 69 then
	   pix(120-1, i, pal[pix(120-1,i)])
		  pix(120, i, pal[pix(120,i)])
		  pix(120+1, i, pal[pix(120+1,i)])
	  end
	 end
		ctrl = not btn(63)
 end
end

camera = {}
 camera.x = -120
 camera.y = -68
 function camera:move()	  
	 if btn(0) and not btn(1) then
	  camera.y=camera.y-1
	 elseif btn(1) and not btn(0) then
	  camera.y=camera.y+1
	 end
	 if btn(2) and not btn(3) then
	  camera.x=camera.x-1
	 elseif btn(3) and not btn(2) then
	  camera.x=camera.x+1	 
	 end  
		
	 if camera.y<=-180 then
	  camera.y=180
	 elseif camera.y>=180 then
	  camera.y=-180
	 end
	 if camera.x<=-260 * zoom then
	  camera.x=260*zoom
	 elseif camera.x>=260* zoom then
	  camera.x=-260*zoom
	 end
	 if btnp(4,60,60) and not btnp(5,60,60) and zoom<=5 then 
	  zoom = zoom + 1
	 elseif btnp(5,60,60) and not btnp(4,60,60) and zoom>=2 then 
	  zoom = zoom - 1
	 end
 end
 
photo = {}
	function photo:add(sprite_id, width, height)
		local s = {}
			s.id = #photo+1
			s.spr_ = sprites_id or 0
			s.w = width or 1
			s.h = height or 1
			s.x = 0
			s.y = 0
			
		table.insert(photo, s)
	end
	function photo:draw()
		for k, s in ipairs(photo) do
			local x = s.x - ((cell * s.w * zoom) / 2) - camera.x
			local y = s.x - ((cell * s.h * zoom) / 2) - camera.y
			local h = (s.h * cell * zoom)+1
			rect(
					x - 1,
					y - 1,
					(s.w * cell * zoom) + 2, 
					h + ((s.h * cell * zoom) / 8),
					12
				)
			spr(
					0, 
					x, 
					y,
					-1, 
					zoom, 
					0,
					0, 
					s.w, 
					s.h
				)
			print("#"..s.id, x, y + h , 15, false, zoom)
		end
	end

particle = {}
function particle:add()
	local i = math.random(60, 100)
	local j = math.random(40, 110)
	
	if #particle <= 300 then
		for x = -240 * zoom, 240 * zoom, i - math.random(23, 53) do
		for y = -136 * zoom, 136 * zoom, j - math.random(13, 37) do
		if math.random(1, 100) == 1 then
		if x > camera.x and x < camera.x + 240 * zoom and y > camera.y and y < camera.y + 136 * zoom then
			local p = {} 
				p.pal = {0,13,14,15,0}
				p.x, p.y = x * zoom, y * zoom
				p.vx = math.random(-14, 14) / 300
				p.vy = math.random(-24, 24) / 600
				p.vt = math.random(13, 17)
				p.t = 0
						
			table.insert(particle, p)
		end
		end
		end 
		end
	end
end

function particle:draw()
 for k, p in ipairs(particle) do
  for i=0,zoom-1 do
   for j=0,zoom-1 do
   	pix(p.x+i-camera.x, p.y+j-camera.y, p.pal[p.t//1])
   end
  end
 end
end

function particle:update()
 for k, p in ipairs(particle) do
  p.x = p.x + p.vx
  p.y = p.y + p.vy
  
  p.t=p.t+(1/p.vt)
  if (p.x-camera.x)<camera.x and (p.x-camera.x)>camera.x+240 and (p.y-camera.y)<camera.y and (p.y-camera.y)>camera.y+136 then
    table.remove(particle,k)
  end
  if #particle>300 then
    table.remove(particle,k)
  end
  
 end
end

info_controls={
 x=0,
 hide = false,
 text={
  [0x0]='To show the controls press "space"',
  [0x1]='To hider the controls press "space"',
  [0x2]='To move press:\n \nTo make the crosshair appear press: ctrl.',
  [0x3]= "WASD"
 },
 draw = function(s) 
	 rect(s.x,s.y,240,s.h,0)
	 rect(s.x+1,s.y+1,240-2,s.h-2,12)
		print(s.text[0x2], s.x+2, s.y+3, 0, false, 1, true)
		function OVR()
		 font(s.text[0x3], s.x+55, s.y+2)
		end
		
		if s.hide then
		  print(s.text[0x0],240-(#s.text[0x0]*3.8),136-8, 12, false, 1, true)
		 else
			 print(s.text[0x1],240-(#s.text[0x1]*3.8),136-8, 12, false, 1, true)
		end
 end,
 update = function(s)
  if s.hide~=true and keyp(48,-1,-1) then
   s.hide=true
  elseif s.hide~=false and keyp(48,-1,-1) then
   s.hide=false
  end
  
  if not s.hide then
   if s.y<0 then
    s.y = s.y + 2
   elseif s.y>0 then
    s.y = 0
   end
  else
   if s.y>-s.h then
    s.y = s.y - 2
   elseif s.y<-s.h then
    s.y = -s.h
   end
  end
 end
}
info_controls.h=13*2
info_controls.y=info_controls.h

function shader_gameboy()
 local c = 55
 for i = 0, 15 do
  for j = 0, 255 do 
  	pal(i,(j+(math.random()*math.sin(i)))+c)
  end
 end
end


photo:add(0, cell-2, cell-1)
function TIC()
 -- shader_gameboy()
 

 --UPDATE
 particle:add()
 camera:move()
 particle:update()
 info_controls:update()
 
 --CLEAR SCREEM
 cls(0)

 --GRAPHICS
 particle:draw()
 photo:draw()
 aim() 
 
 -- UI
 info_controls:draw()
end

-- <TILES>
-- 002:000000000000000f00000fdc00000ccc0000eccc0000dccd000fcdf0000ecfdc
-- 003:000000cc00000fccd0000eccc0000cccde00eccceefeccccd0fccccce0dccccc
-- 004:ce000000cd000000ccf00000cce00000cce0ee00ccffcc00cedccc00e0eeec00
-- 017:00000000000000000000000d000000ec000000ef000000000000000000000000
-- 018:000deecc000ceccdf00deccee0fddccef0feccdd00eeccdc0edeccecdcfeccec
-- 019:fdccccccdcccddcccccdedeeccccccedcccccddcccccceccccccddccccccdccc
-- 020:eddeed00ccceee00ccceedd0dcceefceddcddddcdeeeccecceeeccecccdeccec
-- 021:00000000000000000000000000000000f0000000d0000000c0000000ce000000
-- 032:0000000000000000000000000000000000000000000000000000000000ff0000
-- 033:000ecddc000ecccc0000cccc0000ecec00000ffd000000ed000000cd0000fccd
-- 034:cdeecceccddecceecfcddcceefceddeceecdcfdcfdcecceeeccecccceccdccde
-- 035:ccccdcccccccecccccccecccccdcedcccd0cdefcf00ccdecce0ddeccdcceeecd
-- 036:ccdccceccceccceccceccdfccddccdfccecccffcddccdfdcedceeddc0dcdcddc
-- 037:ce000000ce000000ce000000ce000000ce000000ce000000ce000000cd000000
-- 048:0eddee00eddddd00dcdcdd00dcdcdc00dcdcdc00dcecdc00dcecdc00dcdcdc00
-- 049:0000dccd000fcccd000eccce000eccee000ecedd0000cecd0000dddc00000eed
-- 050:eeccde00dfdfddeceedecdecddddcdececddcdfceeedcceddc0edccedceddccd
-- 051:00fffeddf000fded000000eef000defcd00ecd0ccdeccfcccccceecceddefccc
-- 052:0eddcdec0eddccfcdcddccdeccddccceccedccceccecccdeccecceecceccdecc
-- 053:cc000000ccf00000ccd00000dcce0000ccccf000ccccf000dcce0000d0000000
-- 064:ececdcf0dcccccefccccccefccddccdecdddccdcccccdecccccddccccccdcccd
-- 065:00000efd00000def00000dde00000cdd0000cced0000eecc00000dcc000ecccc
-- 066:ddeccccccefcccccececcccceccecdecfddeecdedf0dfdccccecc0dcccecce0d
-- 067:defddcccccccccccccccdcccccccddccdcccccccdedcccccccdccccddddeeffe
-- 068:ddccecccecccecccdfececcededfecc0dcdeccd0eeecccceeeeccccdccedcccd
-- 069:e0000000f000000000000000000000000000000000000000e0000000d0000000
-- 080:cccdcccfccccccd0eccccce00ccccc000ecccc000dcccc000ccccd00fccccd00
-- 081:000ecccc0000edcc000000ec000000fc0000000d0000eddd0000cccc000dcccd
-- 082:cceccd00cceccc0eccddce0ecccdd0e0ccd000d0f000eef00000000000000000
-- 083:00fefdccedcdecccdddeeccc000efecc000eeddf00feeef000df000000000000
-- 084:ccedcccfcdecdcceccecceccccdfcefeffefef0000dccd0000dcccd000dcccce
-- 096:eccccd00dccccd00ccccce00ccccce00ccccc000000000000000000000000000
-- 097:000ccccd00eccccc00dccccc0fcccccd0cccccc0000000000000000000000000
-- 100:00dccccd00dccccd00eccccd00ecccce000cccc0000000000000000000000000
-- </TILES>

-- <TILES7>
-- 001:eccccd00ccccc000dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 002:dccccd0000000000dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 003:ccccce0000000000dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 004:ccccce0000000000dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 017:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 018:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 019:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 020:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 033:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 034:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 035:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 036:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 049:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 050:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 051:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- 052:dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdc
-- </TILES7>

-- <SPRITES>
-- 065:00000000000f000000fcf0000fccfff0fccccccf0fccfff000fcf000000f0000
-- 068:0000f000000fcf000fffccf0fccccccf0fffccf0000fcf000000f00000000000
-- 083:0000f000000fcf00000fcf0000ffcff00fcccccf00fcccf0000fcf000000f000
-- 087:000f000000fcf0000fcccf00fcccccf00ffcff0000fcf00000fcf000000f0000
-- </SPRITES>

-- <SPRITES1>
-- 068:0000000000010000000100000001000001111100001110000001000000000000
-- 076:0000000000010000001100000111111000110000000100000000000000000000
-- 082:0000000000000000000010000000110001111110000011000000100000000000
-- 085:0000000000001000000111000011111000001000000010000000100000000000
-- </SPRITES1>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:00000001fffffffe00000001fffffffe
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000206000000000
-- 001:031003100310031003100310031003100310031003100310031003100310031003100310031003100310031003100310031003100310031003100310048000000000
-- </SFX>

-- <PATTERNS>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000100000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b180
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

-- <PALETTE1>
-- 000:000000ffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PALETTE1>

