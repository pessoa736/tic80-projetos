-- [resumo]
-- erroLibary: tratamento de erro simples com pcall.
-- check_error(fn, msg_ok, msg_erro) executa fn protegida e acumula as falhas na
-- tabela local `errors`; return_error(msg) registra um erro manualmente.
-- ------------------------------------------------------------

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
