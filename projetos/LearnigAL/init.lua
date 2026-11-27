-- [resumo]
-- LearnigAL: estudo de álgebra linear em Lua (o 'AL' provavelmente é Álgebra Linear).
-- Constrói conjuntos como predicados (ver sets.lua): R_N(N) = vetores com N
-- componentes reais. GetCannonBaseRN(N) monta a base canônica (matriz identidade);
-- CreateSpace é um esqueleto de espaço vetorial ainda incompleto.
-- Obs.: GetCannonBaseRN não retorna B (falta `return B`).
-- ------------------------------------------------------------
--require("tic")

SETS = require("sets")

function R_N(N)
    return SETS.createSet(
        function (v)
            if type(v)~= "table" then return false end
            if #v ~= N then return false end

            for i=1, N do
                if not RealSET(v[i]) then return false end
            end

            return true
        end
    )
end

function GetCannonBaseRN(N)
    local B = {}
    for i = 1, N do
        B[i] = {}
        for j = 1,N do 
            B[i][j] = i==j and 1 or 0
        end
    end
end


local R2 = R_N(2)
local R3 = R_N(3)

print(R3({1, 4}))

function CreateSpace(rules)
    local S = {
        criterio = rules.criterio or false;
    }

end



