-- [resumo]
-- Backup do PDS (Pudim Drawings System) em 30/08/2024 -- versão com PDS.UI e lista
-- de desenhos. A versão atual está em projetos/pudimFOS/system/.
-- ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
----Pudim Drawings Sistem----Pudim Drawings Sistem----Pudim Drawings Sistem----Pudim Drawings Sistem----Pudim Drawings Sistem----
---------------------------------------------------------------------------------------------------------------------------------
-- By Xpudding


PDS = {
    UI ={
        rect = function(PDS, pos, size, color)
            local u ={ 
                pos = pos or PVB(0, 0),
                size = size or PVB(4, 4),

                draw = function(s)
                    rect(s.pos.x, s.pos.y, s.size.x, s.size.y, color)
                end
            }
    
            u:init()
            table.insert(PDS.drawings, u)
        end,
    },
    drawings = {},
    draw = function(s)
        for i, d in ipairs(s) do
            pcall(function()
                d:draw()
                s[i] = nil
            end)
        end
    end
}
