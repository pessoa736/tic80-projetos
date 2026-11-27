# tic80-projetos

Meus projetos, testes e experimentos feitos no [TIC-80](https://tic80.com) (quase tudo em Lua; um pouco de Python), resgatados do HDD antigo. Vão de matemática (fractais, álgebra linear, redes neurais) a jogos e **sistemas operacionais fictícios** (a minha linha de projeto mais recorrente: PudimSystem, pudimFOS, daviSystem).

## Mapa

| Pasta | O que tem |
|---|---|
| [`libraries/`](libraries/) | libs Lua reutilizáveis: vec2/vec3, matrizes, rede neural, colisão, diálogo, camadas... |
| [`projetos/`](projetos/) | projetos principais: engines (PudimEngine, dreamworld), engine 3D, pudimFOS/PuddingSystem, cookie clicker, dino com IA, RPG... |
| [`projetos_inacabado/`](projetos_inacabado/) | protótipos que parei: daviSystem, metroidvania, RPG, flappy bird (com IA), Super Mario, galeria de desenhos... |
| [`projetos_terminados/`](projetos_terminados/) | cannon_newton e fractal de Mandelbrot |
| [`testes/`](testes/) | testes pequenos: bolas, bala, fogo, menu, múltiplos arquivos |
| [`projetos/LearnigAL/`](projetos/LearnigAL/) | estudo de álgebra linear em Lua (conjuntos como predicados) |

Cada pasta tem seu próprio README com a lista do que há dentro, e cada `.lua`/`.py`/`.sh` ganhou um bloco `[resumo]` no topo explicando o que faz.

## Fios que ligam tudo

- **vec2 / lerp** são copiados de projeto em projeto (quase todo arquivo recria o `vec2` com metatable).
- **Engine própria:** PudimEngine v0.4 -> v0.5 (rpg, dreamworld, daviSystem2).
- **Sistemas operacionais fictícios:** windows.tic -> daviSystem 1/2 -> PuddingSystem -> pudimFOS (com CPU simulada por coroutines, memória e fila de desenho).
- **IA/redes neurais** feitas à mão: ia.tic, ia_imagem.tic, rede_neural.lua, flapbirdia.tic, dinogulugulu.lua.

## Como abrir

- Carts `.tic`: abra o TIC-80 na pasta, `load nome.tic` e `run`.
- Arquivos `.lua`: `load nome.lua` dentro do TIC-80 (cart de arquivo externo).
- Vários projetos usam `package.path` com caminhos antigos (`G:/Meu Drive/...`, `H:/Meu Drive/...`, `C:/Users/fenan/...`). Ajuste para o seu caminho antes de rodar; os READMEs apontam onde isso acontece.

## Não incluído

Carts demo padrão do TIC-80, jogos da comunidade, executáveis `.exe`, e `tic_topos.tic` (autoria de petet e Xan Drake, não é meu).

## Origem

`.../arquivos de programação/tic-80/appdata` no HDD antigo, mais `~/.local/share/com.nesbox.tic/TIC-80/LearnigAL` e `programs/lua/pudimSystem`.
