-- title:  Sprite made of strings
-- author: Xpudding
-- desc:   turns strings into sprites
-- script: lua
-- [resumo]
-- sprPixStr: desenha sprites 8x8 a partir de strings hexadecimais (sprString).
-- Usado pelos ícones do daviSystem.
-- ------------------------------------------------------------

Debug=Debug or false

function sprString(str, x, y)
 local cell = 8
 local x = x or 0
 local y = y or 0
 for Str = 0, #str do
  pix(x+((Str-1)%8), ((Str//8)%8)+y, tonumber(str:sub(Str,Str),16))
  if Debug==true then
   trace(tonumber(str:sub(Str,Str),16))
  end
 end
 if Debug==true then
  exit()
 end
end

function TIC()
 cls(12)
 sprString("0000111100001111000011110000111111110000111100001111000011110000", 0, 0)
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

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

