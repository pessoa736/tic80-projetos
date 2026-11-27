-- [resumo]
-- lerp: interpolação linear a*(1-t)+b*t. Retorna a função (require).
-- ------------------------------------------------------------
function lerp(a, b, t)
	return a*(1-t)+b*t
end

return lerp