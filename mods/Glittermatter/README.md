# Glittermatter

A RimWorld mod about what happens when a colony gets hold of the disposable
mass-production technology of a civilization vastly more advanced than itself.

> **Status: v1 implemented, awaiting in-game verification.** The material
> and the reactor exist; textures are placeholders. Targets RimWorld 1.6.

## Elevator pitch

**Glittermatter is the cheap plastic of the glitterworlds:** a mass of
programmable nanomachines that can rapidly solidify into almost any rigid
material structure. On the Rim, it functions as a universal
`Woody`/`Stony`/`Metallic` building material — nonflammable, reasonably
durable, ugly-but-acceptable, and extraordinarily fast to build with.
Purpose-made materials remain better: stone is tougher, wood prettier,
plasteel stronger. Glittermatter's advantage is that it's **good enough for
almost anything, right now**.

Its key technology is the **Matter Reactor**, which uses large amounts of
power, ambient matter, and existing glittermatter as seed material to produce
more. Reactors require rare technology and glittermatter to bootstrap, but
once established make bulk material effectively renewable. Raw glittermatter
is deliberately almost worthless, so industrial-scale production doesn't
become an infinite-money machine.

More advanced technology exploits what glittermatter actually *is*. **Matter
Controllers** let connected glittermatter structures build and repair
themselves, allowing prepared colonies to grow fortifications during combat.
**Matter Fabricators** turn researched weapon designs into standardized
equipment almost at the push of a button: Standard patterns reproduce
conventional weapons cheaply and quickly; Precision patterns use extravagantly
sophisticated technology to reach beyond Excellent-quality performance; and
late-game Master patterns reproduce roughly Masterwork-level performance
deterministically, replacing years of skilled crafting with enormous research
and infrastructure investment.

Later developments include **Smartmatter**, a partially flexible form intended
for self-maintaining, thermoregulating clothing, and advanced composites
incorporating scarce materials such as plasteel and gold.

The overall design principle is:

> **Glittermatter is rarely the best material for anything. It's very often
> the easiest material for everything.**

## Components

| Piece | Role | Implementation |
| --- | --- | --- |
| Glittermatter | Universal `Woody`/`Stony`/`Metallic` stuff. Nonflammable, strong, fastest thing in the game to build with, poor armour, plain. | **done** |
| Matter Reactor | 1×1, 500 W, 6.25 glittermatter/day. Scale by building more. | **done** |
| Glittermatter workbench | Where "fast to make" lives — the stuff itself crafts at normal speed. | XML |
| Matter Fabricator | Researched designs → standardized equipment. Standard / Precision / Master patterns. | XML |
| Smartmatter | Partially flexible form. Self-maintaining, thermoregulating clothing. | XML |
| Composites | Glittermatter alloyed with scarce materials (plasteel, gold). | XML |
| Matter Controller | Connected structures build and repair themselves; fortifications grow during combat. | **C#** — deferred |

## Roadmap

Rough ordering, not a commitment.

1. ~~**The material and the reactor.**~~ Shipped as v1. These could not be
   separated: a reactor is the only source of glittermatter, so a
   material-only release would have shipped something unobtainable.
2. **The workbench.** Fast crafting, gated behind a building rather than
   granted by the stuff.
3. **The fabricator.** Standard, then Precision, then Master patterns. Turns
   the mod from a material into a manufacturing tree.
4. **Smartmatter and composites.** Apparel and the scarce-material alloys.
5. **The controller.** Self-building structures. Needs C#, Harmony, and a
   .NET SDK that isn't installed yet — a separate spec when the time comes.

## Implementation notes

Verified against RimWorld 1.6.4871, not recalled:

- **Multi-category stuff is native.** `StuffProperties.categories` is a
  `List<StuffCategoryDef>`, so a single stuff can be `Woody`, `Stony` and
  `Metallic` simultaneously and will be accepted by anything that takes any
  of the three. The mod's central mechanic needs no patching.
- Vanilla defines exactly five stuff categories: `Metallic`, `Woody`,
  `Stony`, `Fabric`, `Leathery`. Smartmatter has the latter two available.
- **Fabricated equipment sidesteps quality by not having it.** `RecipeDef`
  carries no quality-forcing field and `CompQuality` exposes nothing
  settable from XML, so quality on crafted goods is always rolled from the
  crafter's skill. Pattern tiers therefore ship as distinct ThingDefs with
  no `CompQuality` and stats baked in — the same way components have no
  quality. Deterministic by construction, and no C# involved.

## Open questions

- One ThingDef per weapon per pattern tier multiplies quickly. Which weapons
  are actually worth fabricating?
- Reactor output, power draw and build cost are first-pass numbers. They want
  play testing, not more arithmetic.

Answered in v1: the reactor produces autonomously via stock
`CompProperties_Spawner` — no C# needed. "Ambient matter" is flavour on the
power draw; the reactor's machines leach elements from the rock below, which
costs power and nothing else.
