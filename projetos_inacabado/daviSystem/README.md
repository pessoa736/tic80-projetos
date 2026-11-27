# daviSystem

Fictional OS in TIC-80.

- **daviSystem1/**: workspace with wallpaper, windows, taskbar with date, start menu and `createAPP(app, iconString)` (icon = 64-character hex string). `sprPixStr.lua` draws sprites from strings; `Backup/` keeps an earlier version.
- **daviSystem2/**: rewrite on top of engine v0.4 (vec2, `texrect`, `sprtex`, `new_program`). It has both `.lua` and `.tic`.

**Warning:** `daviSystem2/daviSystem2.lua` already had a syntax error (`function arguments expected near 'end'`, around original line 155) before the comments were added; use the `.tic` version.
