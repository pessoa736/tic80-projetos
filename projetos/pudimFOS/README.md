# pudimFOS

A fictional OS built on Lua (original repository: https://github.com/pessoa736/pudimFOS).

Each module is a fictional "piece of hardware":

| Module | Acronym | Role |
|---|---|---|
| `system/PDS(TIC80).lua` | Pudim Drawings System | layered render queue, palette through `poke` |
| `system/PSPU(TIC80).lua` | Pudim System Processing Unit | simulated CPU: cores and coroutine processes |
| `system/PVB(TIC80).lua` | Pudim Vector Bidimensional | 2D vector |
| `system/ROMMUPS(TIC80).lua` | Read-Only Memory Manipulation Unit | reads/writes TIC-80 memory (0x04000..0x0FF7F) |
| `main(TIC80).lua` | - | builds the `OS` table and wires everything |

`create_build.sh` concatenates `main` + `system/*` into `build/<type>/release<N>.lua` (a single cart). `build/TIC80/release1.lua` is a generated build.

This copy was imported **without the `.git` history** (the original lives in the repo linked above).
