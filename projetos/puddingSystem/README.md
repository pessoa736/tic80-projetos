# puddingSystem

Área de trabalho fictícia com pastas e arquivos em memória.

- `PuddingSysteem.lua`: desktop + taskbar + ícones por extensão.
- `folders.lua`: `createFolder(nome)` com `addFolder` / `addFiles`.
- `packimagem.lua`: wallpapers como matrizes de cor.
- `pudimsystem_3.0.lua`: versão 3 (importada de `programs/lua/pudimSystem/`). Usa um módulo `proc` que **não está neste repo**.

Os `package.path` apontam para `G:/Meu Drive/...` e `~/.local/share/com.nesbox.tic/...`; ajuste antes de rodar.
Veja também: `windows.tic` (protótipo) e `pudimFOS` (versão modular).
