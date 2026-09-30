# Backlog

Deferred work, with the reason it was deferred. Entries move out of here when the reason stops holding.

- **`shellcheck` and a `make lint` target** — not installed. Add both together; a lint target that silently no-ops when
  the linter is absent is worse than no target at all.

- **`bats-support` / `bats-assert`** — not packaged for Arch. Plain `[[ ]]` assertions are adequate at five tests;
  revisit if the suite grows.

- **release-please** — `webui-forge-maestro` uses it, but a Workshop mod ships via Steam rather than GitHub releases,
  and monorepo configuration is not worth writing before there is anything to release. `CHANGELOG.md` is maintained by
  hand until then.

- **Static def cross-reference checker** — `make check` validates XML syntax only. It cannot catch a `<thingDef>` that
  references a def which does not exist; only loading the game does. A checker would close that gap and is a project in
  its own right.

- **AI-use disclosure in the Workshop description** — `README.md` carries one, but Workshop subscribers never see the
  README. `About.xml`'s `<description>` needs a condensed version before publishing. It has to cover generated art now,
  not only generated prose, which is the half a subscriber can actually see.

- **Start-page bookmark and PR-dashboard repo icon** — from the new-project checklist. Deferred until there is something
  worth linking to.

- **Glittermatter should not be recoverable when deconstructed** — all stored energy is spent hardening it in place, so
  there should be nothing left to reclaim. Needs a Harmony patch on `RimWorld.GenLeaving`;
  `resourcesFractionWhenDeconstructed` lives on `BuildableDef` and `StuffProperties` has no per-stuff equivalent.
  Requires a .NET SDK, which is not installed.

- **Proper Glittermatter art** — the PNGs under `mods/Glittermatter/Common/Textures/` are hand-drawn placeholders. They
  render, but they are rough and very dark; the resource in particular reads as a near-black lump. Wanted before
  publishing. Ludeon's own textures are packed in Unity bundles and copyrighted — they must never be committed here.

- **Matter reactors should eat rubbish** — filth and dropped junk within a short radius collected and destroyed, the way
  the trashcan mods do it. The lore has the machines taking apart anything refined they can reach, and rock only because
  it is what is there. Flavour rather than throughput: output should stay on the reactor's own clock, so that tidying
  the floor is not a production strategy. No vanilla comp destroys filth, so it needs a custom `ThingComp` and therefore
  a .NET SDK, which is not installed — the same blocker as the deconstruct patch.

- **Where the source art lives** — three generated reference images (reactor, resource, shotgun line) are sitting in
  `~/downloads` rather than the repo. When one is a keeper it goes in plain git, not LFS: 2.5MB across three files, and
  git's trouble with binaries is churn rather than size. Deferred because they are drafts — the reactor still wants
  scaling and darkening — and the rule is to commit the keeper, not the attempts. `art/<mod>/` at the repo root is the
  intended home, which keeps them out of the mod folder, since that ships to the Workshop, and out of
  `Common/Textures/`, since the game loads whatever it finds there into memory as a texture.

- **Reactor balance** — output rate, power draw and build cost are all first-pass. They want play testing rather than
  arithmetic.
