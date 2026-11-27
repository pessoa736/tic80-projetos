# bullet_heavem

Bullet hell prototype: player with acceleration/velocity smoothed by `coslerp`, entities with life. `include/vec2.lua` is the vector lib.
`main.lua` has a `biuld` flag: `false` loads vec2 from `~/.local/share/com.nesbox.tic/TIC-80/bullet_heavem/include`, `true` assumes a concatenated build. `debug_run.sh` is practically empty.
