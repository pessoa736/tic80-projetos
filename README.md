# tic80-projetos

Meus projetos, testes e experimentos feitos no [TIC-80](https://tic80.com) (principalmente Lua), resgatados do HDD antigo.

## Estrutura

| Pasta | Conteúdo |
|---|---|
| `projetos/` | projetos em andamento/concluídos: engines (PudimEngine, dreamworld, 3d_engine), pudimFOS, puddingSystem, cookie clicker, genericRpg, redes neurais, etc. |
| `projetos_inacabado/` | protótipos que não terminei: daviSystem, metroidvania, rpg, flap bird, super mario, desenhos_de_xpudding... |
| `projetos_terminados/` | cannon_newton, fractal de Mandelbrot |
| `testes/` | testes pequenos (bullet, fogo, menu, múltiplos arquivos) |
| `libraries/` | libs Lua reutilizáveis (vec2, vec3, matriz, shader, layers, dialog_box, ...) |

## Como abrir

- Carts `.tic`: `tic80 --fs . ` e `load nome.tic` + `run`
- Arquivos `.lua`: `load nome.lua` dentro do TIC-80 (ou `tic80 --cmd "load x.lua & run"`)

## Notas

- `projetos/pudimFOS/` também tem repo próprio: https://github.com/pessoa736/pudimFOS
- Não incluídos: carts demo padrão do TIC-80, jogos da comunidade, executáveis `.exe`.
