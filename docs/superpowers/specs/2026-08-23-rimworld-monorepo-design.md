# RimWorld mod monorepo — design

Date: 2026-08-23
Status: approved

## Purpose

Stand up a monorepo that hosts every RimWorld mod I write, and scaffold the
first one — **Glittermatter**, a nanomachine implementation — as an XML-only
content mod targeting RimWorld 1.6.

The repo is public (`Odalrick/rimworld-mods`, MIT). Glittermatter is intended
for the Steam Workshop eventually, so the structure must not need rewriting
when publishing day arrives.

Out of scope: the Glittermatter game design itself. That gets its own spec.

## Verified facts about mod load folders

These were established by disassembling `Assembly-CSharp.dll` from RimWorld
1.6.4871, not from memory or wiki recall. They drive the layout, so the
evidence is recorded here.

`Verse.ModContentPack.InitLoadFolders()` builds `foldersToLoadDescendingOrder`.
Absent a `loadFolders.xml`, it is:

1. `<ModRoot>/<CurrentVersion>/` — e.g. `1.6/` — if that directory exists.
   If it does not, the game scans the mod root for directories whose names
   parse as versions and picks the highest one at or below the current
   version.
2. `<ModRoot>/Common/` — `ModContentPack.CommonFolderName`, the literal
   string `"Common"` — if that directory exists.
3. `<ModRoot>/` itself, unconditionally.

Consequences:

- **The mod root always loads.** It is the lowest-priority entry, not a
  fallback that gets skipped when a version folder is present. Nothing
  version-specific may live at the root.
- **A `1.6/` folder keeps working on 1.7** via the highest-version-at-or-below
  scan, until a `1.7/` folder is added.

`Verse.DirectXmlLoader.XmlAssetsInModFolder(mod, folderPath, ...)` resolves
content across those folders:

- It walks `foldersToLoadDescendingOrder` in order, and for each, recursively
  (`SearchOption.AllDirectories`) collects `*.xml` under
  `<loadFolder>/<folderPath>`.
- Each file is keyed by its path **relative to its load folder** into a
  `Dictionary<string, FileInfo>` via `TryAdd`.

`TryAdd` means **first writer wins**, and the walk is in descending priority.
Therefore a file at the same relative path in a higher-priority folder
**replaces** the lower one wholesale — an override, not a merge, and not a
duplicate-def error. `1.6/Defs/Things.xml` overrides `Common/Defs/Things.xml`.

Also observed: files whose names begin with `.` or `._` are skipped, so
`.gitkeep` files and macOS resource forks are harmless.

## Repository layout

```
<repo root>
├── .gitignore
├── .envrc.example
├── CLAUDE.md
├── README.md
├── CHANGELOG.md
├── BACKLOG.md
├── LICENSE
├── Makefile
├── bin/
│   └── link-mods.sh
├── tests/
│   └── link-mods.bats
├── docs/
│   └── superpowers/specs/
└── mods/
    └── Glittermatter/
        ├── About/
        │   └── About.xml
        └── Common/
            ├── Defs/
            ├── Patches/
            ├── Languages/
            └── Textures/
```

`mods/` groups the mod folders so `bin/` scripts can glob `mods/*` and so the
repo's own files stay clearly separate from shippable content. The directory
name under `mods/` is what gets symlinked into the game; RimWorld does not care
what it is called, `packageId` is the identity.

### Why content lives in `Common/`

`Common/` is part of the versioned-folder mechanism, not an alternative to it:
it is the game's designated home for content that is not version-specific.
Nanomachine defs are not 1.6-specific, so they belong there.

No `1.6/` directory is created yet — there is nothing version-specific to put
in it, and an empty directory is not a design. When 1.7 breaks a specific file,
that one file is copied to `1.7/` at the same relative path and overrides. The
mechanism is understood and documented in `CLAUDE.md`; materialising an empty
folder adds nothing.

Putting everything under `1.6/` instead was rejected: it would mean duplicating
the entire mod for every future game version.

No `loadFolders.xml`. Its only purpose is overriding the default convention,
and the default convention is exactly what is wanted.

## Mod metadata

`mods/Glittermatter/About/About.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<ModMetaData>
  <packageId>odalrick.glittermatter</packageId>
  <name>Glittermatter</name>
  <author>Odalrick</author>
  <supportedVersions>
    <li>1.6</li>
  </supportedVersions>
  <description>...</description>
</ModMetaData>
```

`About/Preview.png` and `About/PublishedFileId.txt` arrive later.
`PublishedFileId.txt` is written by the game on first Workshop publish and
**is committed** — it is the Workshop item identity, needed for every
subsequent update.

No `modDependencies` are declared. Expansion dependencies (Biotech, Royalty,
…) get added when a def actually requires one; declaring them pre-emptively
narrows the audience for nothing.

## Development loop

The repo is bridged into the game by symlink: `<RimWorld>/Mods/Glittermatter`
points at `<repo>/mods/Glittermatter`. Edits are live in the repo with no
deploy step, and the Workshop uploader writes `PublishedFileId.txt` back into
the repo where it belongs.

Rejected alternatives: an `rsync` deploy script (adds a step to every
iteration and invites editing a stale copy) and hosting the repo inside the
game's `Mods/` directory (a Steam file-verify or reinstall can wipe it).

### Task runner

`make` is the entry point for everything. Bare `make` prints the available
targets, scraped from `## Description` annotations on each target — the
annotation style already used in `quick-portraits` and `yog-sothoth`, with the
`help` target those repos are missing.

| Target | Does |
| --- | --- |
| `make` / `make help` | List targets |
| `make link` | Symlink every mod into the game's `Mods/` |
| `make check` | Validate all mod XML |
| `make test` | Run the shell tests |

`RIMWORLD_DIR` is the only environment variable anything reads, and the
default already resolves on a standard Steam install. A committed
`.envrc.example` documents it for direnv; the real `.envrc` is gitignored,
because it holds a machine-specific absolute path and this is a public repo.

Logic lives in a script only when it is worth testing on its own.
`bin/link-mods.sh` earns that; XML validation is a single `xmllint`
invocation and stays inline in its recipe rather than becoming a wrapper
script that does nothing.

### `bin/link-mods.sh`

- Resolves the game directory from `$RIMWORLD_DIR`, defaulting to
  `${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld`.
  `$HOME`-relative by construction — no machine-specific absolute path enters
  the public repo.
- Symlinks every `mods/*` directory into `<RimWorld>/Mods/`.
- Idempotent: re-running is a no-op when links are already correct.
- **Refuses to clobber a real directory.** It replaces only symlinks, so it
  cannot destroy a manually installed mod of the same name.
- Reports what it did.

### Iterating

Edit XML, restart RimWorld, read the log. The log is at
`~/.config/unity3d/Ludeon Studios/RimWorld by Ludeon Studios/Player.log`; the
README documents tailing it. This is a one-line command and does not warrant a
wrapper script.

## Testing

There is no test harness for RimWorld XML defs — the game is the runtime.
Stating that plainly rather than pretending otherwise:

**Automated.** `make check` runs `xmllint --noout` over all XML under
`mods/`, exiting non-zero on failure. It catches malformed XML in about a
second, before the game is ever launched. Its limit is real: it validates
syntax only. It cannot tell that a `<thingDef>` references a def that does not
exist.

Per the standing rule that passing tests are not evidence of coverage, this
is verified by deliberately corrupting an XML file and confirming a non-zero
exit — not by observing that it passes.

`bin/link-mods.sh` has real logic — idempotency, and refusing to clobber a
real directory — so it gets tests. `tests/link-mods.bats` runs it against a
throwaway `RIMWORLD_DIR` and asserts each behaviour, via `make test`.

Tests use **bats** (`extra/bats`, installed as a system package). No helper
libraries: plain `[[ ]]` assertions against bats' `$status` and `$output` are
enough for five tests, and `bats-support`/`bats-assert` are not packaged.

`shellcheck` is not installed. A `make lint` target needs it, and both are
recorded in `BACKLOG.md`; a lint target that silently no-ops when the linter
is absent would be worse than none.

**Manual acceptance gate.** RimWorld loads with the mod enabled and dev mode
on, producing zero red errors in the log. This is the real test.

**Deferred.** A static def cross-reference checker would close the gap between
the two. It is a project in its own right; recorded in `BACKLOG.md`.

## Conventions

- **Git identity is set locally on this repo** to `Odalrick` /
  `odalrick@gmail.com`, because the global `user.name` is the real name. This
  matches `webui-forge-maestro`.
- No personal hostnames or machine-specific absolute paths in committed files.
- Licence MIT, `Copyright (c) 2026 Odalrick`. Default branch `main`.
- Conventional commits. Scopes: `glittermatter`, `bin`, `docs`, `repo`. Each
  new mod adds its own scope.
- Branches are `feat/` or `fix/` only.
- Semver. Starts at `0.1.0`; `1.0.0` is reserved for the first Workshop
  publish.
- `.gitignore` covers `tmp/`, `.locked-branches`, and editor droppings. It
  deliberately does **not** ignore `About/PublishedFileId.txt`.
- `CHANGELOG.md` is maintained by hand. Automating it with release-please, as
  `webui-forge-maestro` does, is deferred to `BACKLOG.md`: a Workshop mod is
  distributed by Steam rather than GitHub releases, and monorepo release-please
  needs per-mod configuration that is not worth writing before there is
  anything to release.

## Registration chores

From the new-project checklist:

- **Now:** create the public GitHub remote `Odalrick/rimworld-mods`.
- **Later:** start-page bookmark, and a repo icon SVG registered in the PR
  dashboard's `_ICON_FILES` map. Deferred until there is something worth
  linking to.
- **Not applicable:** Caddy hostname (no local dev server), wiki.

The checklist calls for `~/projects/<name>`; this repo sits one level deeper,
under the pre-existing `_modding/` grouping. That placement is deliberate. The
local directory is `rimworld` while the GitHub repo is `rimworld-mods` — the
`_modding/` parent supplies the context that a bare public repo name cannot.

## Toolchain notes

`xmllint`, `rsync`, `git` and `mono` are present. There is **no `dotnet` SDK**
installed, which is fine: an XML-only mod compiles nothing. Adding C# and
Harmony later requires installing a .NET SDK first, and is a separate spec.
