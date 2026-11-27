# puddingSystem

Fictional desktop with folders and files held in memory.

- `PuddingSysteem.lua`: desktop + taskbar + icons by extension.
- `folders.lua`: `createFolder(name)` with `addFolder` / `addFiles`.
- `packimagem.lua`: wallpapers as color matrices.
- `pudimsystem_3.0.lua`: version 3 (imported from `programs/lua/pudimSystem/`). It uses a `proc` module that is **not in this repo**.

The `package.path` entries point to `G:/Meu Drive/...` and `~/.local/share/com.nesbox.tic/...`; adjust them before running.
See also: `windows.tic` (prototype) and `pudimFOS` (modular version).
