# projetos

## Folders

| Folder | Summary |
|---|---|
| [`engines/`](engines/) | **PudimEngine v0.5** and the **dreamworld** game built on top of it |
| [`3d_engine/`](3d_engine/) | experimental 3D engine (cube, projection, sorted faces) |
| [`pudimFOS/`](pudimFOS/) | modular fictional operating system (also has its own repo) |
| [`puddingSystem/`](puddingSystem/) | PuddingSystem: desktop with folders + `pudimsystem_3.0.lua` |
| [`pudimSystem backup 30-08-24/`](pudimSystem%20backup%2030-08-24/) | earlier backup of the pudimFOS pieces |
| [`cookie_clicker/`](cookie_clicker/) | Cookie Clicker clone (cookieTICker) |
| [`genericRpg/`](genericRpg/) | generic RPG + Krita artwork |
| [`bullet_heavem/`](bullet_heavem/) | bullet hell prototype (smooth movement) |
| [`LearnigAL/`](LearnigAL/) | linear algebra / sets in Lua |
| [`idle/`](idle/) | project skeleton + `make.sh` |
| [`1/`](1/) | sketch of a button/UI framework |

## Loose files

| File | What it is |
|---|---|
| `dinogulugulu.lua` | Chrome dino with a **neural-network bot** |
| `rede_neural.lua` | object-oriented feed-forward network |
| `convertion_filter.lua` | 2D convolution (3x3 kernel) over the screen |
| `pudimSO.py` | prototype of the fictional OS in **Python** |
| `a.lua` | test scratch (`path.package` should be `package.path`) |
| `sprs.png` | loose spritesheet |

## Carts (`.tic`)

| Cart | What it does |
|---|---|
| `3dtest.tic` | 3D cube with `vec3` and rotations (rotxy/rotzy/rotxz). Bug: `vec3.__add` sums `a.z+a.z` |
| `ia.tic` | neural network with a variable number of hidden layers (sigmoid, feedforward) |
| `ia_imagem.tic` | network with random weights that reads sprite pixels (`sget`) |
| `paint.tic` | mouse paint program (240x136 area) |
| `pix.tic` | experiments with `pix` and base-4 conversion |
| `rotate_screem.tic` | angle rotation, `target_angle` |
| `space2dsimulator.tic` | 2D gravity simulation between circular bodies |
| `speed_time.tic` | objects affected by a "speed of time" (gravity 9.807, 1 px = 1 cm) |
| `test_fractal3.tic` | iterative trajectory of the Mandelbrot set |
| `waifu2x.tic` | upscales a sprite 2x by interpolating neighbors (inspired by waifu2x) |
| `windows.tic` | desktop prototype with folders and taskbar (predecessor of PuddingSystem) |

> `tic_topos.tic` was in this folder but belongs to petet and Xan Drake (a community voxel flyer), so it was removed.
