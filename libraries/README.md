# libraries

Libs Lua pequenas que reaproveitei em vários carts. Em geral são copiadas para dentro de cada projeto (o TIC-80 não tem `require` fácil), por isso aparecem versões repetidas por aí.

| Arquivo | O que faz | Notas |
|---|---|---|
| `vec2.lua` | vetor 2D com operadores sobrecarregados | base de quase tudo |
| `vec3.lua` | vetor 3D | usado na 3d_engine |
| `matriz.lua` | matrizes (`mat`, `matT`, produto com `*`) | usada por shader e 3d_engine |
| `lerp.lua` | interpolação linear | |
| `neuralLibary.lua` | rede feed-forward (só inferência) | usada pelo dinogulugulu |
| `check_colision.lua` | colisão por tile via função injetada | usada pelo genericRpg |
| `dialog_box.lua` | texto com efeito de digitação | tem um `TIC()` de demo |
| `erroLibary.lua` | `check_error` com `pcall` | |
| `layers.lua` | camadas de desenho | **rascunho:** usa `item`, que não existe |
| `pix.lua` | aritmética de pixels | **rascunho:** metamethods ficam em `vector`, não em `Pix` |
| `shader.lua` | desenha matriz como pixels, `And`/`Or` | `package.path` fixo em `G:/...` |
