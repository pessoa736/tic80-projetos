-- title:   Mandelbrot Fractal
-- author:  xpudding
-- desc:    Navigable Mandelbrot set with zoom
-- site:    https://github.com/pessoa736/tic80-projetos
-- license: MIT License
-- version: 0.1
-- script:  lua
-- [resumo]
-- Fractal de Mandelbrot navegável.
-- Setas movem a câmera, botões A/B (4/5) dão zoom in/out; 50 iterações por pixel.
-- ------------------------------------------------------------

zoom=0.0068
interation=50
spdzoom=1/(10^3)
cam={x=0,y=0}

function TIC()
 if btn(0) then cam.y=cam.y-1/zoom end
 if btn(1) then cam.y=cam.y+1/zoom end
 if btn(2) then cam.x=cam.x-1/zoom end
 if btn(3) then cam.x=cam.x+1/zoom end
 if btn(5) then zoom=zoom-spdzoom end
 if btn(4) then zoom=zoom+spdzoom end
 cls(0)
 for x=10,230 do
 for y=10,126 do
  local dx = (x-120+cam.x)/(10000*zoom)
  local dy = (y-68+cam.y)/(10000*zoom)
  
  local a = dx
  local b = dy
  
  for t=0,interation do
  
   local d = (a^2)-(b^2)+dx
   b = 2*(a*b)+dy
   a = d
   
   local H = d>interation
   if H then pix(x,y,t*0.5) break end 
  end
 end
 end
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

