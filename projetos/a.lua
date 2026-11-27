
str = ""
for k, v in pairs(_G) do
	str = str .. " " .. k
end
 print(str)


path.package = path.package .. "C:/Users/fenan/Desktop/test/?.lua"

require "b"

print("1 + 1 =" .. oneplusone())
