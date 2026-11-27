# LearnigAL

**Linear algebra** study in Lua (the "AL" is probably Álgebra Linear). It comes from `~/.local/share/com.nesbox.tic/TIC-80/LearnigAL`.

Idea: a **set** is a predicate, i.e. `Set(v)` answers whether `v` belongs to it.

- `sets.lua`: `SETS.createSet`, `:contains`, `:createSubSet` and the sets `NaturalSET`, `IntegersSET`, `RationalSET` (continued fraction), `IrrationalSET`, `RealSET`, `ComplexSET`.
- `init.lua`: `R_N(N)` (vectors with N real components), canonical basis and a `CreateSpace` skeleton.
- `tic.lua`: redirects `print` to `trace` so it can run outside the TIC-80 interface (the `require("tic")` is commented out in `init.lua`).

**Known issues:** `GetCannonBaseRN` does not return the matrix; in `ComplexSET` the test `k ~= "a" or k ~= "b"` is always true (it should be `and`); `CreateSpace` is incomplete.
