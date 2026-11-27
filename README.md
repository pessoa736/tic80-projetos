# tic80-projetos

Meus projetos, testes e experimentos feitos no [TIC-80](https://tic80.com) (quase tudo em Lua; um pouco de Python), resgatados do HDD antigo. Vão de matemática (fractais, álgebra linear, redes neurais) a jogos e **sistemas operacionais fictícios** (a minha linha de projeto mais recorrente: PudimSystem, pudimFOS, daviSystem).

## Contexto: acervo histórico

Este repositório é um **arquivo de projetos antigos**: jogos, demos, bibliotecas e experimentos para o TIC-80, feitos na minha adolescência, época em que dediquei muito tempo a isso. O código reflete esse período (estilo e nomes inconsistentes, protótipos inacabados, bugs conhecidos, caminhos do Windows antigo) e foi **preservado como estava**: a importação só acrescentou documentação e metadados, sem alterar a lógica.

### Período coberto

Intervalo pelas datas de **última modificação (mtime)** dos 108 arquivos importados do HDD, lidas do sistema de arquivos:

| | Data | Arquivo |
|---|---|---|
| Mais antigo | **2020-09-19** | `testes/test_fogo.tic` |
| Mais recente | **2024-11-21** | `projetos/idle/main.lua` e `make.sh` |

Ou seja, de **set/2020 a nov/2024** (cerca de 4 anos e 2 meses). Arquivos por ano: 2020: 1, 2021: 9, 2022: 24, 2023: 3, 2024: 71.

Ressalvas técnicas sobre essas datas:

- **A data de criação não é recuperável.** No HDD, o birth time de todos os arquivos é 2026-11-14 (dia da migração para este disco). Como criação ≤ modificação, 2020-09-19 é só um limite superior para o primeiro arquivo; ele pode ser anterior.
- **Há uma modificação em lote.** 34 arquivos têm o mesmo mtime (2024-03-15, 22:39-22:40), de uma operação em massa de causa não identificada. A autoria real desses é anterior a essa data.
- **Exceção recente:** `projetos/LearnigAL/` (jun/2026) vem do TIC-80 instalado hoje e não faz parte do acervo da adolescência. Já `puddingSystem/pudimsystem_3.0.lua` (ago/2024) faz.
- **O histórico do git deste repo não reflete a autoria:** ele começa na importação (2026-11-27). Para o pudimFOS, o histórico original (2024-08-30 a 2024-10-03) está no [repo dele](https://github.com/pessoa736/pudimFOS).

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

## License

[MIT](LICENSE). The metadata header of each cart/script (`title`, `author`, `desc`, `site`, `license`, `version`) is filled in English. Exception: `projetos_inacabado/desenhos_de_xpudding/desenhos.lua` declares its own "Proprietary software" license for the drawings.

## Origem

`.../arquivos de programação/tic-80/appdata` no HDD antigo, mais `~/.local/share/com.nesbox.tic/TIC-80/LearnigAL` e `programs/lua/pudimSystem`.
