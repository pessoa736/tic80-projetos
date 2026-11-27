# libraries

Small Lua libs that I reused across many carts. They are usually copied into each project (TIC-80 has no easy `require`), which is why repeated versions show up around the repo.

| File | What it does | Notes |
|---|---|---|
| `vec2.lua` | 2D vector with overloaded operators | base of almost everything |
| `vec3.lua` | 3D vector | used in 3d_engine |
| `matriz.lua` | matrices (`mat`, `matT`, product with `*`) | used by shader and 3d_engine |
| `lerp.lua` | linear interpolation | |
| `neuralLibary.lua` | feed-forward network (inference only) | used by dinogulugulu |
| `check_colision.lua` | tile collision through an injected function | used by genericRpg |
| `dialog_box.lua` | text with a typewriter effect | has a demo `TIC()` |
| `erroLibary.lua` | `check_error` with `pcall` | |
| `layers.lua` | draw layers | **draft:** uses `item`, which does not exist |
| `pix.lua` | pixel arithmetic | **draft:** metamethods live in `vector`, not in `Pix` |
| `shader.lua` | draws a matrix as pixels, `And`/`Or` | `package.path` hardcoded to `G:/...` |
