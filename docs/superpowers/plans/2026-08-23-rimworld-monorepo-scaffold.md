# RimWorld Mod Monorepo Scaffold Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stand up the `rimworld-mods` monorepo — hygiene files, a `make`-driven task runner, a tested mod-linking script, and the Glittermatter mod skeleton — and publish it to GitHub.

**Architecture:** A git repo whose `mods/*` directories are symlinked into RimWorld's `Mods/` folder, so edits are live with no deploy step. `make` is the single entry point; logic lives in a shell script only where it is worth testing on its own. Mod content sits in `Common/`, RimWorld's designated version-agnostic load folder.

**Tech Stack:** GNU make, bash, bats, `xmllint` (libxml2), git, `gh`. No .NET SDK — the first mod is XML-only.

Spec: `docs/superpowers/specs/2026-08-23-rimworld-monorepo-design.md`

---

## File Structure

| File | Responsibility |
| --- | --- |
| `.gitignore` | Local-only paths and editor noise. Deliberately does *not* ignore `PublishedFileId.txt`. |
| `.envrc.example` | Documents `RIMWORLD_DIR` for direnv. The real `.envrc` is gitignored. |
| `LICENSE` | MIT, `Copyright (c) 2026 Odalrick`. |
| `Makefile` | The only entry point. Self-documenting via `##` annotations; owns no logic beyond one-liners. |
| `bin/link-mods.sh` | Symlinks `mods/*` into the game. Idempotent, refuses to clobber real directories. Owns the `RIMWORLD_DIR` default. |
| `tests/link-mods.bats` | bats tests for the above, against a throwaway fixture directory. |
| `CHANGELOG.md` | Hand-maintained, Keep a Changelog format. |
| `BACKLOG.md` | Deferred work, with the reason it was deferred. |
| `CLAUDE.md` | Repo conventions plus the verified load-folder rules. |
| `README.md` | Exists. Gains a Development section. |
| `mods/Glittermatter/About/About.xml` | Mod identity. |
| `mods/Glittermatter/Common/Defs/` | Where the first def lands. |

**Deviation from the spec's tree, flagged for approval during execution:** the spec shows `Common/{Defs,Patches,Languages,Textures}`. Only `Defs/` is created here. The other three are speculation, and the same YAGNI reasoning that removed the empty `1.6/` directory applies to them — they appear when they have content. RimWorld skips dot-prefixed files, so the `.gitkeep` holding `Defs/` open is inert.

---

## Chunk 1: Repo foundation

### Task 1: Hygiene files

**Files:**
- Create: `.gitignore`
- Create: `.envrc.example`
- Create: `LICENSE`
- Create (untracked): `.envrc`

- [ ] **Step 1: Write `.gitignore`**

```gitignore
# Local-only. .envrc holds a machine-specific RimWorld path;
# copy .envrc.example and edit it.
tmp/
.locked-branches
.envrc

# Editor noise
.idea/
.vscode/
*.swp

# NOTE: mods/*/About/PublishedFileId.txt is deliberately NOT ignored.
# It is the Steam Workshop item identity and is required to publish updates.
```

- [ ] **Step 1b: Write `.envrc.example`**

```bash
# Copy to .envrc and run: direnv allow
#
# Where RimWorld is installed. Only needed when it is somewhere other than
# the default bin/link-mods.sh assumes:
#   ${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld
# A second Steam library on another drive is the usual reason.
export RIMWORLD_DIR="$HOME/.local/share/Steam/steamapps/common/RimWorld"
```

Then create the local copy and enable it:

```bash
cp .envrc.example .envrc
direnv allow
```

Expected: direnv reports loading `RIMWORLD_DIR`, and `git status --porcelain`
does not list `.envrc`.

- [ ] **Step 2: Write `LICENSE`**

Standard MIT text, with `Copyright (c) 2026 Odalrick`. Copy the wording from
`~/mcp/webui-forge-maestro/LICENSE` so the two repos match exactly.

- [ ] **Step 3: Verify nothing already-committed becomes ignored**

Run: `git status --porcelain --ignored | grep '^!!' || echo "nothing ignored"`
Expected: no tracked file appears. `tmp/` does not exist yet, so the list should be empty.

- [ ] **Step 4: Commit**

```bash
git add .gitignore .envrc.example LICENSE
git commit -m "chore(repo): add gitignore, direnv example and MIT licence"
```

### Task 2: Makefile with a self-documenting help target

**Files:**
- Create: `Makefile`

- [ ] **Step 1: Write the Makefile**

```makefile
.DEFAULT_GOAL := help
.PHONY: help

help: ## List available targets
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-8s\033[0m %s\n", $$1, $$2}'
```

Only `help` exists yet. Each later task adds its own target name to `.PHONY`
alongside the recipe, rather than declaring them all up front — a name in
`.PHONY` with no rule still fails with "No rule to make target", so listing
them early would only advertise targets that do not run.

- [ ] **Step 2: Verify bare `make` lists targets**

Run: `make`
Expected: one line, `  help     List available targets`.

- [ ] **Step 3: Verify the annotation scrape is actually doing the work**

Temporarily delete the ` ## List available targets` comment from the `help`
line, run `make`, and confirm the output is now empty. Restore the comment.
This proves the listing comes from the annotations rather than from anything
hardcoded.

- [ ] **Step 4: Commit**

```bash
git add Makefile
git commit -m "feat(repo): add self-documenting Makefile"
```

### Task 3: Changelog and backlog

**Files:**
- Create: `CHANGELOG.md`
- Create: `BACKLOG.md`

- [ ] **Step 1: Write `CHANGELOG.md`**

Keep a Changelog format, with an `## [Unreleased]` section only. No version
has been released; `1.0.0` is reserved for the first Workshop publish.

- [ ] **Step 2: Write `BACKLOG.md`**

Each entry states what and *why it was deferred*:

- **`shellcheck` and a `make lint` target** — not installed. Add both together;
  a lint target that silently no-ops when the linter is absent is worse than
  no target.
- **`bats-support` / `bats-assert`** — not packaged for Arch. Plain `[[ ]]`
  assertions are adequate at five tests; revisit if the suite grows.
- **release-please** — `webui-forge-maestro` uses it, but a Workshop mod ships
  via Steam rather than GitHub releases, and monorepo config is not worth
  writing before there is a release.
- **Static def cross-reference checker** — `make check` validates XML syntax
  only; it cannot catch a `<thingDef>` pointing at a def that does not exist.
- **AI-use disclosure in the Workshop description** — `README.md` carries it,
  but Workshop subscribers never see the README. `About.xml`'s `<description>`
  needs a condensed version before publishing.
- **Start-page bookmark and PR-dashboard repo icon** — from the new-project
  checklist, deferred until there is something worth linking to.

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md BACKLOG.md
git commit -m "docs(repo): add changelog and backlog"
```

---

## Chunk 2: Mod skeleton and XML validation

### Task 4: Glittermatter skeleton

**Files:**
- Create: `mods/Glittermatter/About/About.xml`
- Create: `mods/Glittermatter/Common/Defs/.gitkeep`

- [ ] **Step 1: Write `About.xml`**

```xml
<?xml version="1.0" encoding="utf-8"?>
<ModMetaData>
  <packageId>odalrick.glittermatter</packageId>
  <name>Glittermatter</name>
  <author>Odalrick</author>
  <supportedVersions>
    <li>1.6</li>
  </supportedVersions>
  <description>Programmable nanomachines as a universal building material. Rarely the best material for anything; very often the easiest material for everything.

Work in progress — not yet playable.</description>
</ModMetaData>
```

- [ ] **Step 2: Create the Defs placeholder**

```bash
mkdir -p mods/Glittermatter/Common/Defs
touch mods/Glittermatter/Common/Defs/.gitkeep
```

- [ ] **Step 3: Verify the XML parses**

Run: `xmllint --noout mods/Glittermatter/About/About.xml && echo OK`
Expected: `OK`.

- [ ] **Step 4: Commit**

```bash
git add mods/Glittermatter
git commit -m "feat(glittermatter): add mod skeleton and About.xml"
```

### Task 5: `make check`

**Files:**
- Modify: `Makefile`

- [ ] **Step 1: Add the recipe**

Add `check` to `.PHONY` and append:

```makefile
check: ## Validate all mod XML
	@find mods -name '*.xml' -print0 | xargs -0 -r xmllint --noout
	@echo "XML OK"
```

`-print0`/`-0` survives spaces in paths. `xargs -r` is what stops a bare
`xmllint --noout` running with no arguments when no XML exists yet — without
it, xargs invokes xmllint anyway, which prints its usage and exits non-zero,
turning an empty tree into a spurious check failure.

- [ ] **Step 2: Verify it passes on the current tree**

Run: `make check`
Expected: `XML OK`.

- [ ] **Step 3: Verify it actually fails on bad XML — do not skip this**

```bash
printf '<Defs><broken></Defs>' > mods/Glittermatter/Common/Defs/broken.xml
make check; echo "exit=$?"
```
Expected: an `xmllint` parse error mentioning `broken.xml`, `exit=` non-zero,
and **no** `XML OK` line.

Then remove it: `rm mods/Glittermatter/Common/Defs/broken.xml`

A green `make check` proves nothing until this step has been seen to fail.

- [ ] **Step 4: Verify the empty-input guard**

```bash
mkdir -p /tmp/rw-check && cd /tmp/rw-check && mkdir -p mods
find mods -name '*.xml' -print0 | xargs -0 -r xmllint --noout; echo "exit=$?"
```
Expected: returns immediately with `exit=0`, does not hang waiting on stdin.

- [ ] **Step 5: Verify `make` still lists the new target**

Run: `make`
Expected: `check` and `help` both listed, alphabetically.

- [ ] **Step 6: Commit**

```bash
git add Makefile
git commit -m "feat(bin): add make check for XML validation"
```

---

## Chunk 3: link-mods.sh, test-first

Five TDD cycles in bats. Each adds one `@test`, watches it fail, then adds the
smallest behaviour that makes it pass. Do not write the finished script in
cycle one — the point is that every branch in it exists because a test
demanded it.

### Task 6: Cycle 1 — creates a symlink for every mod

**Files:**
- Create: `tests/link-mods.bats`
- Create: `bin/link-mods.sh`

- [ ] **Step 0: Confirm bats is available**

Run: `bats --version`
Expected: a version string, e.g. `Bats 1.14.0`.
If it is missing: `sudo pacman -S bats` (needs a password; ask the user).

- [ ] **Step 1: Write the test file**

```bash
#!/usr/bin/env bats

setup() {
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    SCRIPT="$REPO_ROOT/bin/link-mods.sh"
    FIXTURE="$(mktemp -d)"
    mkdir -p "$FIXTURE/Mods"
    export RIMWORLD_DIR="$FIXTURE"
}

teardown() {
    rm -rf "$FIXTURE"
}

# Every directory under mods/. Asserting over these rather than naming
# Glittermatter keeps the tests correct as mods are added.
mod_names() {
    local source
    for source in "$REPO_ROOT"/mods/*/; do
        [[ -d $source ]] && basename "${source%/}"
    done
}

@test "creates a symlink for every mod" {
    run "$SCRIPT"
    [ "$status" -eq 0 ]

    for name in $(mod_names); do
        [ -L "$FIXTURE/Mods/$name" ]
        [ "$(readlink "$FIXTURE/Mods/$name")" = "$REPO_ROOT/mods/$name" ]
    done
}
```

Each test gets its own throwaway install via `setup`, and `teardown` removes
it whether the test passed or failed. The real game directory is never
touched by the suite.

- [ ] **Step 2: Run it and watch it fail**

Run: `bats tests/`
Expected: `1 test, 1 failure` — the script does not exist yet, so `run` sets a
non-zero `$status` and the first assertion fails.

- [ ] **Step 3: Write the minimal script**

```bash
#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rimworld_dir="${RIMWORLD_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld}"
mods_dir="$rimworld_dir/Mods"

for source in "$repo_root"/mods/*/; do
    source="${source%/}"
    name="$(basename "$source")"
    ln -s "$source" "$mods_dir/$name"
    echo "linked   $name"
done
```

```bash
chmod +x bin/link-mods.sh
```

The `RIMWORLD_DIR` default lives here and nowhere else, and is built from
`$HOME` so no machine-specific absolute path enters a public repo.

- [ ] **Step 4: Run and watch it pass**

Run: `bats tests/`
Expected: `1 test, 0 failures`.

- [ ] **Step 5: Commit**

```bash
git add bin/link-mods.sh tests/link-mods.bats
git commit -m "feat(bin): link mods into the game directory"
```

### Task 7: Cycle 2 — idempotent

- [ ] **Step 1: Add the test**

```bash
@test "is idempotent" {
    run "$SCRIPT"
    [ "$status" -eq 0 ]

    run "$SCRIPT"
    [ "$status" -eq 0 ]

    for name in $(mod_names); do
        [ "$(readlink "$FIXTURE/Mods/$name")" = "$REPO_ROOT/mods/$name" ]
    done
}
```

- [ ] **Step 2: Run and watch it fail**

Run: `bats tests/`
Expected: `2 tests, 1 failure`. The second run's `ln -s` refuses to overwrite
an existing path and `set -e` aborts, so `$status` is non-zero.

- [ ] **Step 3: Recognise an already-correct link**

Replace the loop body:

```bash
    target="$mods_dir/$name"

    if [[ -L $target && "$(readlink "$target")" == "$source" ]]; then
        echo "ok       $name"
        continue
    fi

    ln -s "$source" "$target"
    echo "linked   $name"
```

- [ ] **Step 4: Run and watch both pass**

Run: `bats tests/`
Expected: `2 tests, 0 failures`.

- [ ] **Step 5: Commit**

```bash
git add bin/link-mods.sh tests/link-mods.bats
git commit -m "feat(bin): make link-mods idempotent"
```

### Task 8: Cycle 3 — repoints a stale symlink

- [ ] **Step 1: Add the test**

```bash
@test "repoints a stale symlink" {
    local name
    name="$(mod_names | head -1)"
    ln -s /nonexistent/elsewhere "$FIXTURE/Mods/$name"

    run "$SCRIPT"

    [ "$(readlink "$FIXTURE/Mods/$name")" = "$REPO_ROOT/mods/$name" ]
}
```

- [ ] **Step 2: Run and watch it fail**

Run: `bats tests/`
Expected: `3 tests, 1 failure` — the link still points at
`/nonexistent/elsewhere`, because `ln -s` errored on the existing symlink.

- [ ] **Step 3: Replace stale symlinks**

Insert before the final `ln -s`:

```bash
    if [[ -L $target ]]; then
        rm "$target"
        ln -s "$source" "$target"
        echo "relinked $name"
        continue
    fi
```

- [ ] **Step 4: Run and watch three pass**

- [ ] **Step 5: Commit**

```bash
git add bin/link-mods.sh tests/link-mods.bats
git commit -m "feat(bin): repoint stale mod symlinks"
```

### Task 9: Cycle 4 — refuses to clobber a real directory

This is the safety property, and the one test worth being certain about: a bug
here destroys a hand-installed mod.

- [ ] **Step 1: Add the test**

```bash
@test "refuses to clobber a real directory" {
    local name
    name="$(mod_names | head -1)"
    mkdir -p "$FIXTURE/Mods/$name"
    printf 'precious' > "$FIXTURE/Mods/$name/hand-installed.txt"

    run "$SCRIPT"

    # The important half: the directory survives untouched.
    [ -f "$FIXTURE/Mods/$name/hand-installed.txt" ]
    # And the problem is reported rather than scrolling past.
    [ "$status" -ne 0 ]
    [[ "$output" == *"$name"* ]]
}
```

Three assertions on purpose. Not destroying the directory is the property that
matters; the non-zero exit and the named mod are what make the failure
noticeable.

- [ ] **Step 2: Run and watch it fail**

Run: `bats tests/`
Expected: `4 tests, 1 failure`. Read the actual failure output and confirm
which assertion tripped before proceeding — a test that fails for the wrong
reason proves nothing.

- [ ] **Step 3: Handle it explicitly, and keep going**

Full script after this cycle:

```bash
#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rimworld_dir="${RIMWORLD_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld}"
mods_dir="$rimworld_dir/Mods"

blocked=0

for source in "$repo_root"/mods/*/; do
    source="${source%/}"
    name="$(basename "$source")"
    target="$mods_dir/$name"

    if [[ -L $target && "$(readlink "$target")" == "$source" ]]; then
        echo "ok       $name"
    elif [[ -L $target ]]; then
        rm "$target"
        ln -s "$source" "$target"
        echo "relinked $name"
    elif [[ -e $target ]]; then
        echo "blocked  $name — $target exists and is not a symlink" >&2
        blocked=1
    else
        ln -s "$source" "$target"
        echo "linked   $name"
    fi
done

exit $blocked
```

A blocked mod does not stop the others linking; the non-zero exit at the end
reports that something needs attention.

- [ ] **Step 4: Run and watch four pass**

- [ ] **Step 5: Commit**

```bash
git add bin/link-mods.sh tests/link-mods.bats
git commit -m "feat(bin): refuse to replace real directories in Mods"
```

### Task 10: Cycle 5 — a clear error when the game is not found

- [ ] **Step 1: Add the test**

```bash
@test "fails with a clear message when Mods/ is missing" {
    local bare
    bare="$FIXTURE/elsewhere"
    mkdir -p "$bare"          # deliberately no Mods/ inside
    export RIMWORLD_DIR="$bare"

    run "$SCRIPT"

    [ "$status" -ne 0 ]
    [[ "$output" == *"$bare"* ]]
}
```

The error must name the path it tried. "RimWorld not found" without saying
where it looked is the kind of message that wastes ten minutes. Keeping `bare`
inside `$FIXTURE` means `teardown` still cleans it up when an assertion aborts
the test body.

- [ ] **Step 2: Run and watch it fail**

Run: `bats tests/`
Expected: `5 tests, 1 failure` — the loop runs regardless and `ln -s` fails
into a nonexistent directory, so the output does not name `$bare`.

- [ ] **Step 3: Add the guard**

Insert immediately after `mods_dir` is set:

```bash
if [[ ! -d $mods_dir ]]; then
    echo "No Mods directory at: $mods_dir" >&2
    echo "Set RIMWORLD_DIR to your RimWorld install directory." >&2
    exit 1
fi
```

- [ ] **Step 4: Run and watch all five pass**

Run: `bats tests/`
Expected: `5 tests, 0 failures`.

- [ ] **Step 5: Commit**

```bash
git add bin/link-mods.sh tests/link-mods.bats
git commit -m "feat(bin): fail clearly when the game directory is missing"
```

### Task 11: Wire into make, then link for real

**Files:**
- Modify: `Makefile`

- [ ] **Step 1: Add both recipes**

Add `link` and `test` to `.PHONY` and append:

```makefile
link: ## Symlink every mod into RimWorld's Mods/ directory
	@bin/link-mods.sh

test: ## Run the tests
	@bats tests/
```

`link` passes no `RIMWORLD_DIR`; the script owns the default, and the
environment variable passes through when set.

- [ ] **Step 2: Verify `make` lists all four targets**

Run: `make`
Expected: `check`, `help`, `link`, `test`, alphabetically.

- [ ] **Step 3: Verify `make test` passes**

Run: `make test`
Expected: `5 tests, 0 failures`.

- [ ] **Step 4: Link into the real install**

Run: `make link`
Expected: `linked   Glittermatter`.

- [ ] **Step 5: Verify the game sees it**

```bash
ls -l ~/.local/share/Steam/steamapps/common/RimWorld/Mods/
cat ~/.local/share/Steam/steamapps/common/RimWorld/Mods/Glittermatter/About/About.xml
```
Expected: a symlink into the repo, and `About.xml` readable through it.

- [ ] **Step 6: Commit**

```bash
git add Makefile
git commit -m "feat(repo): add make link and make test targets"
```

- [ ] **Step 7: In-game acceptance check — the real gate**

Launch RimWorld and confirm Glittermatter appears in the mod list with the
right name and author, and that the log has no red errors mentioning it.

Log: `~/.config/unity3d/Ludeon Studios/RimWorld by Ludeon Studios/Player.log`
(created on first launch — the game has never been run on this machine).

The mod adds no content yet, so appearing cleanly in the list is the whole of
the expected behaviour. Report the result rather than assuming it.

---

## Chunk 4: Documentation and publication

### Task 12: `CLAUDE.md`

**Files:**
- Create: `CLAUDE.md`

- [ ] **Step 1: Write it**

Sections, in order:

1. **What this is** — one paragraph.
2. **Public-repo identity** — git identity is set locally to `Odalrick` /
   `odalrick@gmail.com` because the global `user.name` is the real name.
   Verify with `git config user.name` before committing. No personal
   hostnames or machine-specific absolute paths in committed files.
3. **Commands** — `make`, `make check`, `make test`, `make link`.
4. **Load folders** — the verified rules, copied from the spec's
   "Verified facts" section: priority `1.6/` → `Common/` → root; the root
   always loads; same relative path in a higher-priority folder overrides
   wholesale via `TryAdd`; dot-prefixed files are skipped. Cite
   `ModContentPack.InitLoadFolders` and
   `DirectXmlLoader.XmlAssetsInModFolder` so it can be re-checked against a
   future game version rather than trusted.
5. **Conventions** — conventional commits with scopes `glittermatter`, `bin`,
   `docs`, `repo`, one per new mod; `feat/` and `fix/` branches only; semver
   with `1.0.0` reserved for the first Workshop publish; `CHANGELOG.md` by
   hand.
6. **Toolchain** — `xmllint` and `mono` present, no .NET SDK. C# and Harmony
   need an SDK installed first and get their own spec.

- [ ] **Step 2: Verify no leaked identifiers**

Run: `grep -rniF -e "$HOME" -e "$(git config --global user.name)" . --exclude-dir=.git || echo clean`
Expected: `clean`.

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "docs(repo): add CLAUDE.md with conventions and load-folder rules"
```

### Task 13: README development section

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Add a Development section before Licence**

Covers: clone, `make` to see targets, `make link` once to install into the
game, then edit XML and restart the game. Mention `RIMWORLD_DIR` for
non-default install locations, and the `Player.log` path for reading errors.

- [ ] **Step 2: Verify the LICENSE reference now resolves**

Run: `test -f LICENSE && echo "LICENSE exists"`
Expected: `LICENSE exists`. The README has referenced it since before it was
created.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs(repo): document the development loop"
```

### Task 14: Publish to GitHub

**This task creates a public repository. Confirm with the user before running
Step 2 — it is outward-facing and cannot be quietly undone.**

- [ ] **Step 1: Final pre-publish check**

```bash
make check && make test
grep -rniF -e "$HOME" -e "$(git config --global user.name)" . --exclude-dir=.git || echo clean
git log --format='%an <%ae>' | sort -u
git status --porcelain
```
Expected: checks pass; `clean`; every commit authored by
`Odalrick <odalrick@gmail.com>`; a clean working tree.

- [ ] **Step 2: Create the remote and push**

```bash
gh repo create Odalrick/rimworld-mods --public --source=. --remote=origin \
  --description "RimWorld mods by Odalrick. Currently: Glittermatter."
git push -u origin main
```

- [ ] **Step 3: Verify**

```bash
gh repo view Odalrick/rimworld-mods --json name,visibility,description
git status -sb
```
Expected: public, described, and `main` tracking `origin/main` with nothing
ahead.
