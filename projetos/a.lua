-- [resumo]
-- Rascunho de teste: lista as chaves de _G e tenta carregar um módulo `b` de
-- outra pasta. Não roda como está: `path.package` deveria ser `package.path`.
-- ------------------------------------------------------------

str = ""
for k, v in pairs(_G) do
	str = str .. " " .. k
end
 print(str)


path.package = path.package .. "C:/Users/fenan/Desktop/test/?.lua"

require "b"

print("1 + 1 =" .. oneplusone())
