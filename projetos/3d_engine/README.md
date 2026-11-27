# 3d_engine

Experimental 3D engine.

| File | Role |
|---|---|
| `main.lua` | creates the cube, pre-renders, draws |
| `projecao.lua` | average depth per face, sorting (painter's algorithm) |
| `math.lua` | aggregates `vec2`, `vec3`, `matriz`, trigonometry, 2D/3D rotations |
| `drawing.lua` | line, triangle and rectangle through interpolation |

It depends on the libs in `../../libraries/` and uses `H:/Meu Drive/tic-80/appdata/` as its root (`addPath`). To run it, change `maindir` to the path of your clone.
