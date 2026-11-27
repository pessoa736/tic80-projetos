-- author: xpudding
-- script: lua

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


