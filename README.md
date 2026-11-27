# tic80-projetos

My projects, tests and experiments made in [TIC-80](https://tic80.com) (almost all in Lua, a little Python), recovered from an old HDD. They range from math (fractals, linear algebra, neural networks) to games and **fictional operating systems** (my most recurring project line: PudimSystem, pudimFOS, daviSystem).

## Context

Archive of my old projects (2020 - 2024): games, demos and libraries for TIC-80, made as a teenager and preserved as they were.

## Map

| Folder | Contents |
|---|---|
| [`libraries/`](libraries/) | reusable Lua libs: vec2/vec3, matrices, neural network, collision, dialog, layers... |
| [`projetos/`](projetos/) | main projects: engines (PudimEngine, dreamworld), 3D engine, pudimFOS/PuddingSystem, cookie clicker, dino with AI, RPG... |
| [`projetos_inacabado/`](projetos_inacabado/) | prototypes I stopped: daviSystem, metroidvania, RPG, flappy bird (with AI), Super Mario, drawings gallery... |
| [`projetos_terminados/`](projetos_terminados/) | cannon_newton and Mandelbrot fractal |
| [`testes/`](testes/) | small tests: balls, bullets, fire, menu, multiple files |
| [`projetos/LearnigAL/`](projetos/LearnigAL/) | linear algebra study in Lua (sets as predicates) |

(Folder names are in Portuguese: `projetos` = projects, `inacabado` = unfinished, `terminados` = finished, `testes` = tests.)

Each folder has its own README listing what is inside, and each `.lua`/`.py`/`.sh` file has a `[resumo]` summary block at the top explaining what it does (those blocks are in Portuguese).

## Threads running through everything

- **vec2 / lerp** are copied from project to project (almost every file recreates `vec2` with a metatable).
- **Own engine:** PudimEngine v0.4 -> v0.5 (rpg, dreamworld, daviSystem2).
- **Fictional operating systems:** windows.tic -> daviSystem 1/2 -> PuddingSystem -> pudimFOS (with a CPU simulated through coroutines, memory and a draw queue).
- **Hand-made AI / neural networks:** ia.tic, ia_imagem.tic, rede_neural.lua, flapbirdia.tic, dinogulugulu.lua.

## How to open

- `.tic` carts: open TIC-80 in the folder, then `load name.tic` and `run`.
- `.lua` files: `load name.lua` inside TIC-80 (external-file cart).
- Several projects use `package.path` with old paths (`G:/Meu Drive/...`, `H:/Meu Drive/...`, `C:/Users/fenan/...`). Adjust them to your own path before running; the READMEs point out where this happens.

## License

[MIT](LICENSE). The metadata header of each cart/script (`title`, `author`, `desc`, `site`, `license`, `version`) is filled in. Exception: `projetos_inacabado/desenhos_de_xpudding/desenhos.lua` declares its own "Proprietary software" license for the drawings.

## Origin

`.../arquivos de programação/tic-80/appdata` on the old HDD, plus `~/.local/share/com.nesbox.tic/TIC-80/LearnigAL` and `programs/lua/pudimSystem`.
