-- [resumo]
-- Ponte para rodar fora do TIC-80: guarda o print original em printTIC e
-- redireciona print para trace (saída no console).
-- ------------------------------------------------------------
---@diagnostic disable: undefined-global

---@type fun(message: string, x: number, y: number, ...: any)
_G["printTIC"] = print

---@type fun(message: string, color: number)
_G["print"] = trace

---@diagnostic enable: undefined-global