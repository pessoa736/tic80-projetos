-- title:   Dialog Box
-- author:  xpudding
-- desc:    Typewriter-style dialog box library
-- site:    https://github.com/pessoa736/tic80-projetos
-- license: MIT License
-- version: 0.1
-- script:  lua
-- [resumo]
-- dialog_box: caixa de diálogo com efeito de digitação (máquina de escrever).
-- dialog_box:write(texto, view, spd) avança as letras a cada frame; :draw() desenha.
-- O arquivo traz um TIC() de demonstração no final.
-- ------------------------------------------------------------

dialog_box={
 t=0,
 text="",
	write=function(s,text,view,spd)
	 local spd = spd or 1
	 if view==false or s.text~=text then
		 s.t=0
			s.text=text
		else
			s.text=text
	  s.t=s.t+spd
		end
	end,
	draw=function(s)
	 if view~=false then
			rect(0,136-32,240,32,12)
			rect(1,136-31,238,30,12)
		 local te=s.text:sub(0,s.t//5)
			print(te,3,136-29)
		end
	end
}


function TIC()
 
 dialog_box:write("a pulepo lepo",true,1)
 cls()
 dialog_box:draw()
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

