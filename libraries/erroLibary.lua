
local errors={}
function check_error(functions, msg1, msg2)
	local sucess, ErroMensage = pcall(function()
		functions()
	end)

	if sucess then
		return msg1
	else
		table.insert(errors, {msg = ErroMensage})
		return msg2 or "erro"
	end
end

function return_error(ErroMensage)
	table.insert(errors, {msg = ErroMensage})
end
