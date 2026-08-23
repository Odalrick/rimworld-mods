# Glittermatter

A RimWorld mod about what happens when a colony gets hold of the disposable
mass-production technology of a civilization vastly more advanced than itself.

> **Status: outline.** Nothing playable yet. Targets RimWorld 1.6.

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
| Glittermatter | Universal `Woody`/`Stony`/`Metallic` stuff. Nonflammable, fast to build with, mediocre at everything. | XML |
| Matter Reactor | Power + ambient matter + seed glittermatter → bulk glittermatter. Bootstrapped, then renewable. | XML |
| Matter Fabricator | Researched designs → standardized equipment. Standard / Precision / Master patterns. | XML |
| Smartmatter | Partially flexible form. Self-maintaining, thermoregulating clothing. | XML |
| Composites | Glittermatter alloyed with scarce materials (plasteel, gold). | XML |
| Matter Controller | Connected structures build and repair themselves; fortifications grow during combat. | **C#** — deferred |

## Roadmap

Rough ordering, not a commitment.

1. **The material.** Glittermatter as a stuff, and a primitive way to obtain
   it. This alone is a playable mod: a generic building material that is
   never optimal and always available.
2. **The reactor.** Bulk production, and the research and bootstrap cost that
   gate it. This is where glittermatter stops being a curiosity and starts
   being infrastructure.
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

- Is "ambient matter" a real consumed resource, or flavour on the reactor's
  power draw?
- Does the reactor produce autonomously, or through bills at a workbench? A
  bill-driven reactor is pure XML; an autonomous one needs a comp, and
  therefore C#.
- One ThingDef per weapon per pattern tier multiplies quickly. Which weapons
  are actually worth fabricating?
- What anchors the balance — how much cheaper and faster than the
  purpose-made material is "good enough for almost anything, right now"?
