# rimworld-mods

A monorepo of RimWorld mods. Each mod is a directory under `mods/`, symlinked
into the game's `Mods/` folder so edits are live without a deploy step.
Currently one mod: Glittermatter, at outline stage.

## Public-repo identity

This is a **public** repo. The git identity is set locally, because the global
`user.name` is the real name:

```bash
git config user.name   # → Odalrick
git config user.email  # → odalrick@gmail.com
```

Both MUST stay that way. Do not commit personal hostnames, absolute paths
under `/home/<user>`, or anything else tying the repo to one machine. That is
why `.envrc` is gitignored and `.envrc.example` is not: the example uses
`$HOME`, the real one may not.

**Stage explicit paths. Never `git add -A` or `git add .`** — placeholder
textures under `mods/*/Common/Textures/` are deliberately untracked, and a
blanket add commits them. Ludeon's art must never enter this repo, and
generated placeholders should not either. `.idea/` was committed exactly this
way before `.gitignore` existed.

## Commands

```sh
make          # list targets
make check    # validate all mod XML (xmllint)
make test     # run the bats tests
make link     # symlink every mod into RimWorld's Mods/ directory
```

`RIMWORLD_DIR` overrides the install location; it defaults to
`${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld`. The
default is defined in `bin/link-mods.sh` and nowhere else.

The game's log — the only place mod load errors appear — is at
`~/.config/unity3d/Ludeon Studios/RimWorld by Ludeon Studios/Player.log`.

## Load folders

Established by disassembling `Assembly-CSharp.dll` from **1.6.4871**. Re-check
against the named methods rather than trusting this section on a new game
version.

`Verse.ModContentPack.InitLoadFolders()` builds the load list. With no
`loadFolders.xml`, it is, highest priority first:

1. `<ModRoot>/<CurrentVersion>/` — e.g. `1.6/` — if it exists. If not, the
   highest-numbered version directory at or below the current version.
2. `<ModRoot>/Common/` — the literal name, from
   `ModContentPack.CommonFolderName`.
3. `<ModRoot>/` itself, **unconditionally**.

So the mod root always loads; it is the lowest-priority entry, not a fallback
that gets skipped. Nothing version-specific may live there.

`Verse.DirectXmlLoader.XmlAssetsInModFolder()` walks that list in order,
recursively collecting `*.xml`, keyed by path relative to its load folder,
using `Dictionary.TryAdd` — **first writer wins**. A file at the same relative
path in a higher-priority folder therefore *replaces* the lower one wholesale.
It is an override, not a merge, and produces no duplicate-def error.

Practical consequence: content lives in `Common/`. When a future version
breaks one file, copy that one file to `1.7/` at the same relative path.
Do not duplicate the mod per version.

Files whose names begin with `.` or `._` are skipped, so `.gitkeep` is inert.

## Conventions

- Conventional commits. Scopes: `glittermatter`, `bin`, `docs`, `repo`. Each
  new mod adds its own scope.
- Branches: `feat/` or `fix/` only. `main` is protected by the pre-commit hook
  symlinked into `.git/hooks/`.
- Semver. `1.0.0` is reserved for the first Steam Workshop publish.
- `CHANGELOG.md` is maintained by hand. Deferred work goes in `BACKLOG.md`
  with the reason it was deferred.
- `About/PublishedFileId.txt` is committed, never ignored — it is the Workshop
  item identity and updates need it.

## Testing

There is no test harness for RimWorld XML; the game is the runtime.

- `make check` validates XML **syntax only**. It cannot catch a def that
  references a def which does not exist.
- `make test` covers `bin/link-mods.sh`, which has logic worth testing —
  idempotency, and refusing to clobber a real directory.
- The real acceptance gate is loading the game with dev mode on and seeing no
  red errors in `Player.log`.

A green `make check` means nothing until you have seen it go red. When adding
a check, break the thing it guards and confirm the failure.

## Toolchain

`xmllint`, `bats`, `direnv` and `mono` are present. There is **no .NET SDK**,
which is fine — the current mod is XML-only and compiles nothing. C# and
Harmony require installing an SDK first and get their own spec.
