-- author: xpudding
-- script: lua
-- [resumo]
-- check_colision: detector de colisão por tile.
-- Guarda uma função de detecção (SetDetectetionFunctions) e converte posição
-- em pixels para coordenada de tile (//8) em c:check(p, cx, cy, s).
-- Uso típico: a função de detecção chama fget(mget(x, y), flag) (ver genericRpg).
-- ------------------------------------------------------------

local c={
  detectetionFunctions = function() end
}

function c.SetDetectetionFunctions(funct)
  c.DetectetionFunctions = funct
end
function c:check(p, cx, cy, s)
  local x=p.x+(cx or 0)
	local y=p.y+(cy or 0)
	return self.detectetionFunctions(x//8, y//8, s)
end


return c


