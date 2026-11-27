# LearnigAL

Estudo de **álgebra linear** em Lua (o "AL" provavelmente é Álgebra Linear). Vem de `~/.local/share/com.nesbox.tic/TIC-80/LearnigAL`.

Ideia: um **conjunto** é um predicado, ou seja, `Set(v)` responde se `v` pertence.

- `sets.lua`: `SETS.createSet`, `:contains`, `:createSubSet` e os conjuntos `NaturalSET`, `IntegersSET`, `RationalSET` (fração contínua), `IrrationalSET`, `RealSET`, `ComplexSET`.
- `init.lua`: `R_N(N)` (vetores com N componentes reais), base canônica e um esqueleto de `CreateSpace`.
- `tic.lua`: redireciona `print` para `trace` para rodar fora da interface do TIC-80 (o `require("tic")` está comentado em `init.lua`).

**Conhecidos / a corrigir:** `GetCannonBaseRN` não retorna a matriz; em `ComplexSET` o teste `k ~= "a" or k ~= "b"` é sempre verdadeiro (deveria ser `and`); `CreateSpace` está incompleto.
