
m = math

function m.lerp(a,b,t)
    return a*(1-t)+b*t
end
   
function m.vectorDistance(x1, x0)
	return x0 - x1
end

function m.distanceBivetor(x0, y0, x1, y1)
	local dx = m.vectorDistance(x0, x1)
	local dy = m.vectorDistance(y0, y1)
	
    return m.sqrt(dx*dx + dy*dy)
end

return m