# rimworld-mods

A monorepo of RimWorld mods. Each mod is a directory under `mods/`, symlinked into the game's `Mods/` folder so edits
are live without a deploy step. Currently one mod: Glittermatter, at outline stage.

## Public-repo identity

This is a **public** repo. The git identity is set locally, because the global `user.name` is the real name:

```bash
git config user.name   # → Odalrick
git config user.email  # → odalrick@gmail.com
```

Both MUST stay that way. Do not commit personal hostnames, absolute paths under `/home/<user>`, or anything else tying
the repo to one machine. That is why `.envrc` is gitignored and `.envrc.example` is not: the example uses `$HOME`, the
real one may not.

**Stage explicit paths. Never `git add -A` or `git add .`** — `.idea/` was committed to this repo exactly that way,
before `.gitignore` existed, and a blanket add is how third-party art or a stray local file ends up published. Ludeon's
textures are copyrighted and must never enter this repo.

## Commands

```sh
make          # list targets
make check    # validate all mod XML (xmllint)
make test     # run the bats tests
make link     # symlink every mod into RimWorld's Mods/ directory
```

`RIMWORLD_DIR` overrides the install location; it defaults to
`${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld`. The default is defined in `bin/link-mods.sh` and
nowhere else.

The game's log — the only place mod load errors appear — is at
`~/.config/unity3d/Ludeon Studios/RimWorld by Ludeon Studios/Player.log`.

## Load folders

Established by disassembling `Assembly-CSharp.dll` from **1.6.4871**. Re-check against the named methods rather than
trusting this section on a new game version.

`Verse.ModContentPack.InitLoadFolders()` builds the load list. With no `loadFolders.xml`, it is, highest priority first:

1. `<ModRoot>/<CurrentVersion>/` — e.g. `1.6/` — if it exists. If not, the highest-numbered version directory at or
   below the current version.
2. `<ModRoot>/Common/` — the literal name, from `ModContentPack.CommonFolderName`.
3. `<ModRoot>/` itself, **unconditionally**.

So the mod root always loads; it is the lowest-priority entry, not a fallback that gets skipped. Nothing
version-specific may live there.

`Verse.DirectXmlLoader.XmlAssetsInModFolder()` walks that list in order, recursively collecting `*.xml`, keyed by path
relative to its load folder, using `Dictionary.TryAdd` — **first writer wins**. A file at the same relative path in a
higher-priority folder therefore _replaces_ the lower one wholesale. It is an override, not a merge, and produces no
duplicate-def error.

Practical consequence: content lives in `Common/`. When a future version breaks one file, copy that one file to `1.7/`
at the same relative path. Do not duplicate the mod per version.

Files whose names begin with `.` or `._` are skipped, so `.gitkeep` is inert.

## Conventions

- Conventional commits. Scopes: `glittermatter`, `bin`, `docs`, `repo`. Each new mod adds its own scope.
- Branches: `feat/` or `fix/` only. `main` is protected by the pre-commit hook symlinked into `.git/hooks/`.
- Semver. `1.0.0` is reserved for the first Steam Workshop publish.
- Lore lives in `mods/<Mod>/lore/` — an `index.md` and a file per concept — and is canonical. In-game descriptions and
  the specs under `docs/` restate it; when they disagree, `lore/` is right and they are stale. `docs/` is for the plan
  and spec of one piece of work, not for permanent fiction.
- Prose is British English, in-game text included. RimWorld's own strings are American; that is the game's business, not
  this repo's, so do not "correct" mêlée, armour or colour to match it.
- Def names are namespaced with the mod: `Glittermatter_Raw`, `Glittermatter_Reactor`, `Glittermatter_Banshee`. A
  `defName` must be unique within its def type across every mod the player has loaded, so a bare `MatterReactor` is the
  collision waiting to happen. `Verse.Def.AllowedDefNamesRegex` is `^[a-zA-Z0-9\-_]*$` — a hyphen would pass, but
  vanilla uses none anywhere in `Data/`, so underscore, as in `Gun_BoltActionRifle`. Renaming a def after publishing
  breaks existing saves; the names have to be right before the first Workshop upload.
- Texture paths are namespaced the same way, and for the same reason: `Glittermatter/Things/Building/MatterReactor`,
  with the files under `Common/Textures/Glittermatter/`. `ContentFinder` resolves a `texPath` across every active mod —
  its own failure message says "in any active mod or in base resources" — and a collision is decided by load order with
  no warning printed. `tests/glittermatter-defs.bats` guards the prefix.
- `CHANGELOG.md` is maintained by hand. Deferred work goes in `BACKLOG.md` with the reason it was deferred.
- `About/PublishedFileId.txt` is committed, never ignored — it is the Workshop item identity and updates need it.

## Testing

There is no test harness for RimWorld XML; the game is the runtime.

- `make check` validates XML **syntax only**. It cannot catch a def that references a def which does not exist.
- `make test` covers `bin/link-mods.sh` — idempotency, and refusing to clobber a real directory — and, in
  `tests/glittermatter-defs.bats`, the def properties whose breakage is invisible during play. Those assert on
  `defName`, so renaming a def turns them red; that is the point.
- The real acceptance gate is loading the game with dev mode on and seeing no red errors in `Player.log`.

A green `make check` means nothing until you have seen it go red. When adding a check, break the thing it guards and
confirm the failure.

## Toolchain

This repo is worked on from more than one computer and the machines differ, so check rather than assume:

```sh
for t in xmllint bats direnv pandoc mono; do command -v "$t" >/dev/null || echo "missing: $t"; done
```

`xmllint` and `bats` are what `make check` and `make test` need; nothing else is required to work on the mod. `direnv`
reads `.envrc`. `pandoc` is for prose that arrives in some other markup. `mono` supplies `monodis`, which is the only
way to disassemble `Assembly-CSharp.dll` here — without it, an engine claim can still be checked with `strings -e l`
against the assembly, which reads literals but not logic. Homebrew has all of them where they are missing.

There is **no .NET SDK** on any machine so far, which is fine — the current mod is XML-only and compiles nothing. C# and
Harmony require installing an SDK first and get their own spec.
