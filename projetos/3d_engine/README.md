# 3d_engine

Engine 3D experimental.

| Arquivo | Papel |
|---|---|
| `main.lua` | cria o cubo, pré-renderiza, desenha |
| `projecao.lua` | profundidade média por face, ordenação (algoritmo do pintor) |
| `math.lua` | agrega `vec2`, `vec3`, `matriz`, trigonometria, rotações 2D/3D |
| `drawing.lua` | linha, triângulo e retângulo por interpolação |

Depende das libs em `../../libraries/` e usa `H:/Meu Drive/tic-80/appdata/` como raiz (`addPath`). Para rodar, troque `maindir` pelo caminho do seu clone.
