local function mat(i,j,ta)
    local t = ta or {} 
    if type(ta)~="table" then
        for i = 1, i do
          t[i] = {}
            for j = 1, j do
                t[i][j] = 0
            end
        end
    end
    local mt = setmetatable(
        t,
        {
            __mul = function(a,b)
                local linhasA = #a
                local linhasB = #b
                local colunasA = #a[1]
                local colunasB = #b[1]
                local c = {} 
                
                if linhasB == colunasA then  
                    for i = 1, linhasA do 
                        c[i]={}
                        for j = 1, colunasB do
                            c[i][j] = 0 
                            for k = 1, linhasB do				
                                c[i][j] = c[i][j] + a[i][k]* b[k][j] 
                            end
                        end
                    end
                end
                return mat(linhasA, colunasB, c)
            end,
            __tostring=function(a)
                local l, c = #a, #a[#a]
                local str= "\n"
                for i = 1, l do
                    for j = 1, c do
                        str = str .. (a[i][j]//1) .. " "
                    end
                    str = str .. "\n"
                end
                return str
            end
        }
    )
    return mt
end
local function matT(ta)
    local t = {}
        for j = 1, #ta[#ta] do
            t[j] = {}
            for i = 1, #ta do
                t[j][i] = ta[i][j]
            end 
        end 
    return mat(#ta, #ta[#ta], t)
end

return mat, matT
   