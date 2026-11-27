---@diagnostic disable: undefined-global

---@type fun(message: string, x: number, y: number, ...: any)
_G["printTIC"] = print

---@type fun(message: string, color: number)
_G["print"] = trace

---@diagnostic enable: undefined-global