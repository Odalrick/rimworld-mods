# rimworld-mods

RimWorld mods by Odalrick, kept in one repo.

## Mods

- **[Glittermatter](mods/Glittermatter/)** — programmable nanomachines as a
  universal building material, growing into a technology tree about
  disposable glitterworld mass-production. *Outline stage; nothing playable
  yet.*

## AI use

I use large language models for a lot of what goes into this repo. Rather
than leave anyone guessing, here is where:

- **Prose** — design documents, mod descriptions and this README are drafted
  with LLM assistance. The Glittermatter elevator pitch was written with
  ChatGPT; the design specs in `docs/` were written with Claude Code.
- **Code and XML** — written with Claude Code, reviewed by me before it
  lands.
- **Art** — none yet. The intention is that I draw the preview and any
  textures myself. If that changes and generated art ships, this section
  will say so.

Everything here is something I chose to keep, and I'm answerable for it
either way.

## Layout

Each mod is a directory under `mods/`. Mod content lives in `Common/`, which
is RimWorld's designated folder for content that isn't tied to a specific
game version; version-specific overrides would go in a sibling `1.6/` (see
`docs/superpowers/specs/` for why, and for the load-order rules this relies
on).

## Development

```sh
git clone git@github.com:Odalrick/rimworld-mods.git
cd rimworld-mods
make          # list what you can do
make link     # symlink every mod into RimWorld's Mods/ directory
```

`make link` is a one-off. After it, edits in this repo are live in the game —
change XML, restart RimWorld, see the result. Re-run it after adding a new
mod.

If RimWorld is not at
`${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld` — a
second Steam library on another drive being the usual reason — set
`RIMWORLD_DIR`. Copy `.envrc.example` to `.envrc` and run `direnv allow`, or
export it yourself.

Before committing:

```sh
make check    # validate mod XML
make test     # run the tests
```

Mod load errors appear only in the game's log:
`~/.config/unity3d/Ludeon Studios/RimWorld by Ludeon Studios/Player.log`

## Licence

MIT. See `LICENSE`.
