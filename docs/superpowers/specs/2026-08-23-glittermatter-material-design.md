# Glittermatter v1 — the material and its source

Date: 2026-08-23
Status: draft — awaiting review

## Purpose

The first playable release of Glittermatter: a universal building material, the
Matter Reactor that produces it, and the research and trade routes that put a
reactor in the player's hands.

Everything is XML. No .NET SDK required.

## Scope

The mod's pitch spans five subsystems — material, reactor, fabricator,
smartmatter/composites, controller. Each gets its own spec. This one covers
**material + reactor together**, because they are not separable: a reactor is
the only source of glittermatter, so a material-only release would ship
something the player can never obtain.

Explicitly **not** in v1:

- The dedicated glittermatter workbench (where "fast to make" will live).
- Matter Fabricator, Matter Controller, Smartmatter, composites.
- A quest that guarantees reactor access. Low priority; trade is judged
  available enough.
- Making glittermatter unrecoverable on deconstruct. Needs C#; see Deferred.

## Fiction

Glittermatter is the cheap plastic of the glitterworlds: a mass of programmable
nanomachines that solidifies into almost any rigid structure.

Building with it is not manual. The builder directs it with a simple
transmitter and the material flows into place and hardens of its own accord,
expending the energy the reactor imparted to it. That simple grade of control
is why it sets dull grey flecked with silver — fused remnants of micromachines
— and probably why it is called glittermatter. (The competing theory is that it
is named for the glitterworlds. Either way, "glitterworlds" is the older word.)

Because every joule stored in the material is spent hardening it in place,
there is nothing left to reclaim from a demolished glittermatter wall. The game
refunds it anyway; see Deferred.

A Matter Reactor holds a seed of glittermatter — millions of distinct molecular
machines. Powered and directed by the reactor, they grow an underground network
of leaching tunnels, dissolve useful elements, and carry them back to be built
into more machines. The research is not "how to make nanomachines" but how to
adapt thousands of existing designs to locally available elements.

## Design principle

> Glittermatter is rarely the best material for anything. It is very often the
> easiest material for everything.

It trades **power and time for labour**. The stat profile below implements
exactly that trade and nothing else.

## Verified engine facts

Established by disassembling `Assembly-CSharp.dll` from **1.6.4871**. Recorded
so they can be re-checked rather than trusted.

- **Multi-category stuff is native.** `Verse.StuffProperties.categories` is a
  `List<StuffCategoryDef>`. One stuff can be `Woody`, `Stony` and `Metallic` at
  once and is accepted by anything taking any of them. Vanilla defines exactly
  five categories: `Metallic`, `Woody`, `Stony`, `Fabric`, `Leathery`.
- **Autonomous production is a stock comp.** `RimWorld.CompProperties_Spawner`
  exposes `thingToSpawn`, `spawnCount`, `spawnIntervalRange`,
  `spawnMaxAdjacent`, `spawnForbidden`, `requiresPower`, `writeTimeLeftToSpawn`,
  `showMessageIfOwned`, `inheritFaction`. The Infinite Chemreactor is nothing
  but this comp on a plain building. No custom class is needed.
- **Armour and damage are absolute `statBases` on the stuff item**, not
  `statFactors`: `StuffPower_Armor_Sharp`, `StuffPower_Armor_Blunt`,
  `StuffPower_Armor_Heat`, `StuffPower_Insulation_Cold`,
  `StuffPower_Insulation_Heat`, `SharpDamageMultiplier`,
  `BluntDamageMultiplier`. **Each has its own range**, so one value applied
  across all of them lands in a different place on each scale.
- **Work does not affect market value.** `StatWorker_MarketValue`
  `.CalculatedBaseMarketValue` reads `CostList`, `CostStuffCount` and quality
  only. Making something faster does not make it cheaper or dearer.
- **Techprints need no Royalty.** `techprintCount`, `techprintCommonality` and
  `techprintMarketValue` are `ResearchProjectDef` fields, and
  `ThingDefGenerator_Techprints` builds the item automatically. Every vanilla
  user tags `Empire`, but `StockGenerator_Techprints` is on Core trader kinds
  (Outlander base/caravan/visitor, Neolithic, Orbital Misc) and `Outlander` is
  a Core faction category tag.
- **Deconstruct refunds are per-building, not per-stuff.**
  `resourcesFractionWhenDeconstructed` is on `Verse.BuildableDef`;
  `StuffProperties` has no refund field. `RimWorld.GenLeaving` computes the
  leavings.

## The material

`Glittermatter` — a raw resource that is also a stuff.

```xml
<tradeability>None</tradeability>
<statBases>
  <MarketValue>1.5</MarketValue>
  <Mass>0.3</Mass>
  <Flammability>0</Flammability>
  <StuffPower_Armor_Sharp>0.45</StuffPower_Armor_Sharp>
  <StuffPower_Armor_Blunt>0.25</StuffPower_Armor_Blunt>
  <StuffPower_Armor_Heat>0.30</StuffPower_Armor_Heat>
  <StuffPower_Insulation_Cold>3</StuffPower_Insulation_Cold>
  <StuffPower_Insulation_Heat>0</StuffPower_Insulation_Heat>
  <SharpDamageMultiplier>0.5</SharpDamageMultiplier>
  <BluntDamageMultiplier>0.8</BluntDamageMultiplier>
</statBases>
<stuffProps>
  <stuffAdjective>glittermatter</stuffAdjective>
  <categories><li>Woody</li><li>Stony</li><li>Metallic</li></categories>
  <commonality>0</commonality>
  <allowedInStuffGeneration>false</allowedInStuffGeneration>
  <isAirtight>true</isAirtight>
  <statFactors>
    <MaxHitPoints>1.4</MaxHitPoints>
    <Beauty>0.9</Beauty>
    <Flammability>0</Flammability>
    <WorkToBuild>0.2</WorkToBuild>
    <WorkToMake>1.0</WorkToMake>
    <DoorOpenSpeed>1.2</DoorOpenSpeed>
  </statFactors>
</stuffProps>
```

Where each value sits:

| Stat | Glittermatter | Wood | Steel | Granite | Plasteel |
| --- | --- | --- | --- | --- | --- |
| `WorkToBuild` | **0.2** | 0.7 | 1.0 | ~6 | 2.2 |
| `MaxHitPoints` | **1.4** | 0.65 | 1.0 | 1.7 | 2.8 |
| `Beauty` | **0.9** | 1.0 | 1.0 | 1.0 | 1.0 |
| `Flammability` | **0** | 1.0 | 0.4 | 0 | 0 |
| `Armor_Sharp` | **0.45** | 0.54 | 0.9 | — | 1.14 |
| `Armor_Blunt` | **0.25** | 0.54 | 0.45 | — | 0.55 |
| `Armor_Heat` | **0.30** | 0.40 | 0.60 | — | 0.65 |
| `SharpDamage` | **0.5** | 0.40 | 1.0 | 0.65 | 1.1 |
| `BluntDamage` | **0.8** | 0.9 | 1.0 | 1.0 | 0.9 |

Notes on specific choices:

- **Armour is half of steel across all three channels.** Applying one flat
  figure would not have produced "poor armour": 0.5 blunt would have been
  *better* than steel's 0.45, because the three stats occupy different ranges.
- **`WorkToBuild` and `WorkToMake` are split.** The transmitter guides bulk
  material into structural shapes, so construction is fast; shaping a sculpture
  or stitching a garment still takes an artisan's hands, so crafting runs at
  normal speed. Without the split, `WorkToMake 0.2` would give roughly 3.5×
  the sculpture output of wood at unchanged market value — art is work-bound
  rather than material-bound, so it is exactly where the player would collect
  glittermatter's benefit while paying none of its material cost. Fast crafting
  arrives later, gated behind the dedicated glittermatter workbench.
- **`Mass 0.3`** — low density is what makes it bulky per unit of value, which
  is the in-fiction reason nobody ships it.
- **`allowedInStuffGeneration false`** keeps glittermatter items off traders and
  raiders. Necessary: the material is meant to be unobtainable without a
  reactor. `BlocksVacstone` sets the same flag.
- **Bed rest effectiveness is deliberately absent.** Omitting the factor means
  1.0 — as good as steel or wood. It is a fine material for furniture; it is
  only unlovely.
- **`commonality 0`** keeps it out of random stuff selection.

Colour: dull grey with silver flecks, around `(150,150,155)`.

## The Matter Reactor

A **1×1** building. Scaling is by count, not by size — a glittermatter supply
is a power farm the player expands, which makes "power for labour" a thing they
physically build.

```xml
<size>(1,1)</size>
<comps>
  <li Class="CompProperties_Power">
    <compClass>CompPowerTrader</compClass>
    <basePowerConsumption>500</basePowerConsumption>
  </li>
  <li Class="CompProperties_Breakdownable"/>
  <li Class="CompProperties_Flickable"/>
  <li Class="CompProperties_Spawner">
    <thingToSpawn>Glittermatter</thingToSpawn>
    <spawnCount>25</spawnCount>
    <spawnIntervalRange><min>240000</min><max>240000</max></spawnIntervalRange>
    <requiresPower>true</requiresPower>
    <writeTimeLeftToSpawn>true</writeTimeLeftToSpawn>
    <spawnMaxAdjacent>150</spawnMaxAdjacent>
  </li>
</comps>
<minifiedDef>MinifiedThing</minifiedDef>
<tradeability>All</tradeability>
```

240,000 ticks is four days, so **6.25 glittermatter per day per tile at 500 W**.
Sixteen tiles is 100/day for 8 kW — a lot of power, comfortably attainable
mid-game, for a hundred units of free material daily. Stone can be produced
faster; stone costs labour.

`spawnMaxAdjacent 150` pauses a reactor whose output is not being hauled, so a
sixteen-tile farm cannot carpet its room. Vanilla's chemreactor omits this;
drop it if the pause proves more annoying than the pile.

First-pass build cost, to be tuned: `Steel 100`, `ComponentSpacer 3`,
`Glittermatter 150` — about 24 tile-days to repay itself.

## Acquisition

**Your first reactor cannot be built.** Its cost list contains glittermatter,
and reactors are the only source, so the first one must be bought or looted.
That is the bootstrap rule expressed as a cost list rather than as special
logic.

Purchase follows the Telescope pattern exactly:

```xml
<li Class="StockGenerator_SingleDef">
  <thingDef>MatterReactor</thingDef>
  <countRange>0~1</countRange>
</li>
```

patched into `Orbital_Exotic` and `Caravan_Outlander_Exotic`. Not
`Base_Outlander_Standard` — a reactor is exotic stock, not general goods.

Research `GlittermatterAdaptation` unlocks *building* reactors:

```xml
<techprintCount>1</techprintCount>
<techprintCommonality>3</techprintCommonality>
<techprintMarketValue>3000</techprintMarketValue>
<heldByFactionCategoryTags><li>Outlander</li></heldByFactionCategoryTags>
```

with `MultiAnalyzer` required and a `Spacer`-tier cost. The research is
adapting the nanomachine design library to local geology — which is why owning
a reactor does not, by itself, let you make another.

## Textures

Vanilla textures are packed inside Unity asset bundles, not shipped as loose
PNGs, and they are Ludeon's copyright — this repo is public and MIT, so they
must not be committed regardless.

Placeholders are therefore **generated**, written to the correct paths and
dimensions, and left **untracked** for hand-editing:

- `Common/Textures/Things/Item/Resource/Glittermatter.png`
- `Common/Textures/Things/Building/MatterReactor.png`

A cloner will see missing-texture errors until real art is committed. That is
acceptable before publication and must be closed before it.

## Testing

- `make check` — XML syntax. Cannot catch a def referencing a def that does not
  exist.
- `make test` — unchanged; covers tooling, not content.
- **Acceptance is in-game**, with dev mode on and a clean log:
  1. Glittermatter appears as a build material for wooden, stone *and* metal
     structures.
  2. A placed reactor consumes 500 W and yields 25 glittermatter after four
     in-game days.
  3. A reactor appears in exotic trader stock (dev-mode trader spawn).
  4. The techprint appears in Outlander trader stock, and the research
     completes with it.
  5. Glittermatter never appears in generated raider or trader goods.

Item 5 is the one most likely to be quietly wrong, and the one least likely to
be noticed by playing normally.

## Deferred

- **Non-recoverable on deconstruct.** Requires a Harmony patch on
  `RimWorld.GenLeaving`; `resourcesFractionWhenDeconstructed` is per-building
  and `StuffProperties` has no per-stuff equivalent. Wants a .NET SDK, which is
  not installed.
- **The glittermatter workbench** — the intended home for fast crafting.
- **Reactor-availability quest.**
- Fabricator, Controller, Smartmatter, composites — each its own spec.
