-- title:   UI Button Framework
-- author:  xpudding
-- desc:    Sketch of a button and front/back-end runner framework
-- site:    https://github.com/pessoa736/tic80-projetos
-- license: MIT License
-- version: 0.1
-- script:  lua
-- [resumo]
-- Esboço de framework de interface: fábrica button() (id, pos, size, action) e
-- filas running_back_end / running_front_end chamáveis via metatable (__call),
-- com log de debug (__debug__). Rascunho: b.draw usa `pos`/`size` sem o `s.`,
-- então o desenho do botão ainda não funciona.
-- ------------------------------------------------------------

__debug__ = true

function button()
  local index = 0
  
  local b = {
 	  add = function(s, args)
      setmetatable(args or {},{
        __index = function(t, key)
          print(key)
          return nil
        end 
      })

      local b ={
        id = index + 1,
        size = args.size or {x=64, y=32},
        pos = args.pos or {x=120, y=68},
        action = args.action or function(s) trace("Button".. s.id .."no_action_") end,
        draw = function(s)
          rect(pos.x, pos.y, size.x, size.y, 12)
        end
      }
      index = index + 1

      table.insert(s, b)
    end,
    update = function (s)
      for i, v in ipairs(s) do
        v:action()
      end
    end
  }
 
  return b
end

running_back_end={}
running_front_end={}
running_meta = {
  __call = function(s)
    local dp = ''
 	  for k, v in ipairs(s) do
      v()
      if __debug__ then
        dp = dp .. k .. '\n\t'
      end
    end
    if #dp>0 then
      trace(dp)
    end
  end,
  __add = function(a, b)
    table.insert(a, b)
  end
}
setmetatable(running_back_end, running_meta)
setmetatable(running_front_end, running_meta)

function BOOT()
  BU = button()

  BU:add()
  local run = running_back_end+function() BU:update() end
end
function TIC()
  running_back_end()
  cls()
  running_front_end()
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

