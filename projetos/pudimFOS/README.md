# pudimFOS

Um OS ficcional em base Lua (repositório original: https://github.com/pessoa736/pudimFOS).

Cada módulo é uma "peça de hardware" fictícia:

| Módulo | Sigla | Papel |
|---|---|---|
| `system/PDS(TIC80).lua` | Pudim Drawings System | fila de renderização por camada, paleta via `poke` |
| `system/PSPU(TIC80).lua` | Pudim System Processing Unit | CPU simulada: núcleos e processos em coroutines |
| `system/PVB(TIC80).lua` | Pudim Vector Bidimensional | vetor 2D |
| `system/ROMMUPS(TIC80).lua` | Read-Only Memory Manipulation Unit | leitura/escrita na memória do TIC-80 (0x04000..0x0FF7F) |
| `main(TIC80).lua` | - | monta a tabela `OS` e liga tudo |

`create_build.sh` concatena `main` + `system/*` em `build/<tipo>/release<N>.lua` (um cart só). `build/TIC80/release1.lua` é um build gerado.

Esta cópia foi importada **sem o histórico `.git`** (o original está no repo próprio acima).
