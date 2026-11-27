# projetos

## Pastas

| Pasta | Resumo |
|---|---|
| [`engines/`](engines/) | **PudimEngine v0.5** e o jogo **dreamworld** feito sobre ela |
| [`3d_engine/`](3d_engine/) | engine 3D experimental (cubo, projeção, faces ordenadas) |
| [`pudimFOS/`](pudimFOS/) | sistema operacional fictício modular (também tem repo próprio) |
| [`puddingSystem/`](puddingSystem/) | PuddingSystem: área de trabalho com pastas + `pudimsystem_3.0.lua` |
| [`pudimSystem backup 30-08-24/`](pudimSystem%20backup%2030-08-24/) | backup anterior das peças do pudimFOS |
| [`cookie_clicker/`](cookie_clicker/) | clone de Cookie Clicker (cookieTICker) |
| [`genericRpg/`](genericRpg/) | RPG genérico + arte em Krita |
| [`bullet_heavem/`](bullet_heavem/) | protótipo de bullet hell (movimento suave) |
| [`LearnigAL/`](LearnigAL/) | álgebra linear / conjuntos em Lua |
| [`idle/`](idle/) | esqueleto de projeto + `make.sh` |
| [`1/`](1/) | esboço de framework de botões/UI |

## Arquivos soltos

| Arquivo | O que é |
|---|---|
| `dinogulugulu.lua` | dino do Chrome com **bot de rede neural** |
| `rede_neural.lua` | rede feed-forward orientada a objetos |
| `convertion_filter.lua` | convolução 2D (kernel 3x3) sobre a tela |
| `pudimSO.py` | protótipo do SO fictício em **Python** |
| `a.lua` | rascunho de teste (`path.package` deveria ser `package.path`) |
| `sprs.png` | spritesheet solta |

## Carts (`.tic`)

| Cart | O que faz |
|---|---|
| `3dtest.tic` | cubo 3D com `vec3` e rotações (rotxy/rotzy/rotxz). Bug: `vec3.__add` soma `a.z+a.z` |
| `ia.tic` | rede neural com número variável de camadas ocultas (sigmoid, feedforward) |
| `ia_imagem.tic` | rede com pesos aleatórios que lê pixels do sprite (`sget`) |
| `paint.tic` | programa de pintura com o mouse (área 240x136) |
| `pix.tic` | experimentos com `pix` e conversão para base 4 |
| `rotate_screem.tic` | rotação por ângulo, `target_angle` |
| `space2dsimulator.tic` | simulação de gravidade 2D entre corpos circulares |
| `speed_time.tic` | objetos afetados por uma "velocidade do tempo" (gravidade 9.807, 1 px = 1 cm) |
| `test_fractal3.tic` | trajetória iterativa do conjunto de Mandelbrot |
| `waifu2x.tic` | amplia sprite 2x interpolando vizinhos (inspirado no waifu2x) |
| `windows.tic` | protótipo de desktop com pastas e taskbar (antecessor do PuddingSystem) |

> `tic_topos.tic` estava nesta pasta mas é de petet e Xan Drake (voxel flyer da comunidade), então foi retirado.
