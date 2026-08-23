# Glittermatter v1 Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the first playable Glittermatter release — a universal building material, the Matter Reactor that produces it, and the research and trade routes that put a reactor in the player's hands.

**Architecture:** Pure XML. Four def files plus one trader patch under `mods/Glittermatter/Common/`. The material is a stuff with three stuff categories; the reactor is a 1×1 building whose entire behaviour is stock `CompProperties_Spawner`. Nothing is compiled.

**Tech Stack:** RimWorld 1.6 XML defs, `xmllint` (validation and test queries), bats, Pillow (placeholder art).

Spec: `docs/superpowers/specs/2026-08-23-glittermatter-material-design.md`

---

## File Structure

| File | Responsibility |
| --- | --- |
| `mods/Glittermatter/Common/Defs/ThingDefs_Items/Glittermatter.xml` | The material: resource stats and `stuffProps`. |
| `mods/Glittermatter/Common/Defs/ThingDefs_Buildings/MatterReactor.xml` | The reactor: 1×1 powered building with `CompProperties_Spawner`. |
| `mods/Glittermatter/Common/Defs/ResearchProjectDefs/GlittermatterAdaptation.xml` | Techprint-gated research that unlocks building reactors. |
| `mods/Glittermatter/Common/Patches/TraderKinds_MatterReactor.xml` | Puts reactors in exotic trader stock. |
| `tests/glittermatter-defs.bats` | Guards the invariants whose breakage is silent in play. |
| `mods/Glittermatter/Common/Textures/**` | Placeholder art. **Untracked** — see Task 1. |

One def type per file, matching how vanilla organises `Data/Core/Defs`.

### A note on what is and isn't tested

There is no test harness for RimWorld defs, and asserting that a config file
contains the numbers you just typed into it is circular — it tests nothing but
your typing.

`tests/glittermatter-defs.bats` is therefore deliberately narrow. It does not
check balance numbers, which are meant to change. It checks the four
properties whose breakage is **invisible during play** and would therefore
survive for months:

- glittermatter is untradeable,
- glittermatter is excluded from generated items,
- it serves all three rigid stuff categories,
- the reactor's cost list contains glittermatter, which is what makes the
  first reactor unbuildable.

Delete any one of those lines from a def and something must go red. Everything
else is verified in-game.

---

## Chunk 1: The material

### Task 1: Placeholder textures

**Files:**
- Create (untracked): `mods/Glittermatter/Common/Textures/Things/Item/Resource/Glittermatter.png`
- Create (untracked): `mods/Glittermatter/Common/Textures/Things/Building/MatterReactor.png`

Vanilla textures are packed inside Unity asset bundles, not shipped as loose
PNGs, and they are Ludeon's copyright — this repo is public and MIT, so they
must not be committed under any circumstances. These are generated from
scratch instead: correct paths, correct dimensions, ready to be painted over.

- [ ] **Step 1: Generate them**

```bash
mkdir -p mods/Glittermatter/Common/Textures/Things/Item/Resource \
         mods/Glittermatter/Common/Textures/Things/Building
python3 - <<'PY'
from PIL import Image, ImageDraw
import random

random.seed(1)  # reproducible placeholders

# Resource: a dull grey lump flecked with silver.
img = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
d = ImageDraw.Draw(img)
d.ellipse((18, 30, 110, 100), fill=(150, 150, 155, 255))
for _ in range(60):
    x, y = random.randint(24, 104), random.randint(36, 94)
    d.point((x, y), fill=(225, 225, 235, 255))
img.save("mods/Glittermatter/Common/Textures/Things/Item/Resource/Glittermatter.png")

# Building: a small grey machine with a lit face.
img = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
d = ImageDraw.Draw(img)
d.rounded_rectangle((10, 10, 118, 118), radius=10, fill=(96, 100, 104, 255))
d.rounded_rectangle((28, 28, 100, 100), radius=6, fill=(60, 63, 66, 255))
d.ellipse((54, 54, 74, 74), fill=(170, 200, 215, 255))
img.save("mods/Glittermatter/Common/Textures/Things/Building/MatterReactor.png")
print("placeholders written")
PY
```

- [ ] **Step 2: Verify size and transparency**

```bash
python3 -c "
from PIL import Image
for p in ('Things/Item/Resource/Glittermatter','Things/Building/MatterReactor'):
    im = Image.open(f'mods/Glittermatter/Common/Textures/{p}.png')
    print(p, im.size, im.mode)
"
```
Expected: `(128, 128) RGBA` for both.

- [ ] **Step 3: Confirm they are untracked, and leave them that way**

Run: `git status --porcelain mods/Glittermatter/Common/Textures/`
Expected: `?? mods/Glittermatter/Common/Textures/`

**Do not `git add` them, and do not add them to `.gitignore`** — the real art
belongs at these exact paths later, so an ignore rule would silently block it.
They stay untracked until hand-drawn art replaces them.

There is no commit in this task.

### Task 2: Never use `git add -A` in this repo

**Files:**
- Modify: `CLAUDE.md`

Untracked-but-wanted files only work if nothing sweeps them up. `.idea/` was
committed to this repo exactly that way before `.gitignore` existed.

- [ ] **Step 1: Add to the Public-repo identity section of `CLAUDE.md`**

```markdown
**Stage explicit paths. Never `git add -A` or `git add .`** — placeholder
textures under `mods/*/Common/Textures/` are deliberately untracked, and a
blanket add commits them. Ludeon's art must never enter this repo, and
generated placeholders should not either.
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs(repo): forbid blanket git add"
```

### Task 3: The material, test-first

**Files:**
- Create: `tests/glittermatter-defs.bats`
- Create: `mods/Glittermatter/Common/Defs/ThingDefs_Items/Glittermatter.xml`

- [ ] **Step 1: Write the invariant tests**

```bash
#!/usr/bin/env bats
#
# Guards the def properties whose breakage is invisible during play.
# Balance numbers are deliberately NOT asserted here — they are meant to change.

setup() {
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    DEFS="$REPO_ROOT/mods/Glittermatter/Common/Defs"
    ITEMS="$DEFS/ThingDefs_Items/Glittermatter.xml"
}

# Evaluate an XPath expression against a def file.
xp() {
    xmllint --xpath "$1" "$2" 2>/dev/null
}

@test "glittermatter cannot be traded" {
    run xp 'string(/Defs/ThingDef[defName="Glittermatter"]/tradeability)' "$ITEMS"
    [ "$output" = "None" ]
}

@test "glittermatter is excluded from generated items" {
    run xp 'string(/Defs/ThingDef[defName="Glittermatter"]/stuffProps/allowedInStuffGeneration)' "$ITEMS"
    [ "$output" = "false" ]
}

@test "glittermatter serves all three rigid stuff categories" {
    local cat
    for cat in Woody Stony Metallic; do
        run xp "count(/Defs/ThingDef[defName=\"Glittermatter\"]/stuffProps/categories/li[text()=\"$cat\"])" "$ITEMS"
        [ "$output" = "1" ]
    done
}
```

- [ ] **Step 2: Run and watch all three fail**

Run: `bats tests/glittermatter-defs.bats`
Expected: `3 tests, 3 failures` — the def file does not exist, so every
`xmllint` call fails and `$output` is empty.

- [ ] **Step 3: Write the def**

`mods/Glittermatter/Common/Defs/ThingDefs_Items/Glittermatter.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Defs>

  <ThingDef ParentName="ResourceBase">
    <defName>Glittermatter</defName>
    <label>glittermatter</label>
    <description>A mass of programmable nanomachines, dull grey and flecked with silver — fused remnants of micromachines spent in earlier work. Directed by a simple transmitter, it flows into place and hardens of its own accord, expending the energy a matter reactor imparted to it.

Structurally excellent and almost instant to build with. It makes poor armour, indifferent weapons, and nothing anyone would call beautiful. On the glitterworlds, it is packing material.</description>
    <graphicData>
      <texPath>Things/Item/Resource/Glittermatter</texPath>
      <graphicClass>Graphic_StackCount</graphicClass>
    </graphicData>
    <soundInteract>Metal_Drop</soundInteract>
    <soundDrop>Metal_Drop</soundDrop>
    <useHitPoints>false</useHitPoints>
    <healthAffectsPrice>false</healthAffectsPrice>
    <burnableByRecipe>false</burnableByRecipe>
    <smeltable>false</smeltable>
    <!-- Too bulky per unit of value to be worth shipping. Nobody trades it. -->
    <tradeability>None</tradeability>
    <terrainAffordanceNeeded>Light</terrainAffordanceNeeded>
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
    <thingCategories>
      <li>ResourcesRaw</li>
    </thingCategories>
    <stuffProps>
      <stuffAdjective>glittermatter</stuffAdjective>
      <categories>
        <li>Woody</li>
        <li>Stony</li>
        <li>Metallic</li>
      </categories>
      <appearance>Metal</appearance>
      <!-- Never chosen for randomly generated items; a reactor is the only source. -->
      <commonality>0</commonality>
      <allowedInStuffGeneration>false</allowedInStuffGeneration>
      <constructEffect>ConstructMetal</constructEffect>
      <isAirtight>true</isAirtight>
      <color>(150,150,155)</color>
      <soundImpactBullet>BulletImpact_Metal</soundImpactBullet>
      <soundMeleeHitSharp>MeleeHit_Metal_Sharp</soundMeleeHitSharp>
      <soundMeleeHitBlunt>MeleeHit_Metal_Blunt</soundMeleeHitBlunt>
      <soundImpactMelee>Pawn_Melee_Punch_HitBuilding_Metal</soundImpactMelee>
      <statFactors>
        <MaxHitPoints>1.4</MaxHitPoints>
        <Beauty>0.9</Beauty>
        <Flammability>0</Flammability>
        <!-- The transmitter guides bulk material into structural shapes, so
             construction is near-instant. WorkToMake is deliberately absent
             (i.e. 1.0): shaping a sculpture still needs an artisan's hands.
             Reducing it here would give ~3.5x the sculpture output of wood at
             unchanged market value, because art is work-bound rather than
             material-bound. Fast crafting belongs to the future glittermatter
             workbench, not to the stuff itself. -->
        <WorkToBuild>0.2</WorkToBuild>
        <DoorOpenSpeed>1.2</DoorOpenSpeed>
      </statFactors>
    </stuffProps>
  </ThingDef>

</Defs>
```

Bed rest effectiveness is absent on purpose — no factor means 1.0, as good as
steel. It is a fine material for furniture; it is only plain.

- [ ] **Step 4: Run and watch all three pass**

Run: `bats tests/glittermatter-defs.bats`
Expected: `3 tests, 0 failures`.

- [ ] **Step 5: Prove the tests actually bite**

Delete the `<tradeability>None</tradeability>` line, run `bats tests/`, and
confirm exactly one test fails. Restore it. A green suite means nothing until
you have watched it go red for the right reason.

- [ ] **Step 6: Validate and commit**

```bash
make check
git add tests/glittermatter-defs.bats mods/Glittermatter/Common/Defs/ThingDefs_Items/Glittermatter.xml
git commit -m "feat(glittermatter): add the glittermatter material"
```

Note the explicit paths — not `git add -A`, which would sweep up the untracked
placeholder textures.

### Task 4: In-game check — the material

- [ ] **Step 1: Launch RimWorld with dev mode on, load a save or start a new colony**

- [ ] **Step 2: Spawn glittermatter**

Dev mode → *Tools: Spawning* → *Try place near thing…* → `Glittermatter`, 200 units.

Expected: it spawns, is named "glittermatter", and shows the placeholder texture.

- [ ] **Step 3: Verify the three stuff categories — this is the core mechanic**

Open the Architect menu and confirm glittermatter is offered as a material for:
- a **wooden** thing (e.g. a wall or door normally built from wood),
- a **stone** thing,
- a **metal** thing.

Expected: offered for all three. If it is missing from any, `stuffProps
categories` did not take effect and nothing else in the mod matters.

- [ ] **Step 4: Verify the build-speed edge**

Compare the work figure on a glittermatter wall against a steel one.
Expected: roughly one fifth.

- [ ] **Step 5: Check the log**

`~/.config/unity3d/Ludeon Studios/RimWorld by Ludeon Studios/Player.log`
Expected: no red errors mentioning `Glittermatter`.

Record what actually happened. Do not mark this task complete on the
assumption that it worked.

---

## Chunk 2: The reactor and its gating

### Task 5: The research project

**Files:**
- Create: `mods/Glittermatter/Common/Defs/ResearchProjectDefs/GlittermatterAdaptation.xml`

Written before the reactor because the reactor references it.

- [ ] **Step 1: Write the def**

```xml
<?xml version="1.0" encoding="utf-8"?>
<Defs>

  <ResearchProjectDef>
    <defName>GlittermatterAdaptation</defName>
    <label>glittermatter adaptation</label>
    <description>Glittermatter is not one machine but thousands of designs, each suited to elements that happen to be abundant somewhere. A techprint carries that design library. Adapting it to the rock under your feet is the work; the control transmitters themselves are simple once you hold the programs.</description>
    <baseCost>2000</baseCost>
    <techLevel>Spacer</techLevel>
    <prerequisites>
      <li>Electricity</li>
    </prerequisites>
    <!-- The techprint is the gate. No research bench requirement on top of it. -->
    <techprintCount>1</techprintCount>
    <techprintCommonality>3</techprintCommonality>
    <techprintMarketValue>3000</techprintMarketValue>
    <heldByFactionCategoryTags>
      <li>Outlander</li>
    </heldByFactionCategoryTags>
    <researchViewX>9.00</researchViewX>
    <researchViewY>4.20</researchViewY>
  </ResearchProjectDef>

</Defs>
```

`Outlander` is a Core faction tag and Core trader kinds already run
`StockGenerator_Techprints`, so this adds no Royalty dependency. Every vanilla
techprint tags `Empire`, which would have.

- [ ] **Step 2: Validate**

Run: `make check`
Expected: `XML OK`.

- [ ] **Step 3: Commit**

```bash
git add mods/Glittermatter/Common/Defs/ResearchProjectDefs/GlittermatterAdaptation.xml
git commit -m "feat(glittermatter): add techprint-gated adaptation research"
```

### Task 6: The reactor, test-first

**Files:**
- Modify: `tests/glittermatter-defs.bats`
- Create: `mods/Glittermatter/Common/Defs/ThingDefs_Buildings/MatterReactor.xml`

- [ ] **Step 1: Add the bootstrap invariant test**

In `setup()`, add:

```bash
    BUILDINGS="$DEFS/ThingDefs_Buildings/MatterReactor.xml"
```

and append:

```bash
@test "the first reactor cannot be built" {
    # The cost list contains glittermatter, and reactors are its only source.
    # This one line is the entire bootstrap rule; without it the mod's
    # progression collapses and nothing in play would look wrong.
    run xp 'count(/Defs/ThingDef[defName="MatterReactor"]/costList/Glittermatter)' "$BUILDINGS"
    [ "$output" = "1" ]
}
```

- [ ] **Step 2: Run and watch it fail**

Run: `bats tests/glittermatter-defs.bats`
Expected: `4 tests, 1 failure`.

- [ ] **Step 3: Write the def**

```xml
<?xml version="1.0" encoding="utf-8"?>
<Defs>

  <ThingDef ParentName="BuildingBase">
    <defName>MatterReactor</defName>
    <label>matter reactor</label>
    <description>A seed of glittermatter, powered and directed. Its molecular machines grow a network of leaching tunnels through the rock below, dissolve whatever useful elements they find, and carry them back to be built into more of themselves.

It is neither fast nor efficient. It simply never stops, and it never asks anyone to do the work.</description>
    <graphicData>
      <texPath>Things/Building/MatterReactor</texPath>
      <graphicClass>Graphic_Single</graphicClass>
      <drawSize>(1,1)</drawSize>
    </graphicData>
    <size>(1,1)</size>
    <rotatable>false</rotatable>
    <altitudeLayer>Building</altitudeLayer>
    <passability>Impassable</passability>
    <fillPercent>1.0</fillPercent>
    <canOverlapZones>false</canOverlapZones>
    <tickerType>Normal</tickerType>
    <designationCategory>Production</designationCategory>
    <terrainAffordanceNeeded>Medium</terrainAffordanceNeeded>
    <researchPrerequisites>
      <li>GlittermatterAdaptation</li>
    </researchPrerequisites>
    <!-- Glittermatter in the cost list is the bootstrap rule: a reactor is the
         only source of glittermatter, so the first one must be bought or
         looted. Removing this makes the mod self-starting. -->
    <costList>
      <Steel>100</Steel>
      <ComponentSpacer>1</ComponentSpacer>
      <Glittermatter>150</Glittermatter>
    </costList>
    <statBases>
      <MaxHitPoints>120</MaxHitPoints>
      <WorkToBuild>3000</WorkToBuild>
      <Flammability>0</Flammability>
      <Beauty>-4</Beauty>
      <Mass>20</Mass>
    </statBases>
    <thingCategories>
      <li>BuildingsSpecial</li>
    </thingCategories>
    <minifiedDef>MinifiedThing</minifiedDef>
    <tradeability>All</tradeability>
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
        <!-- 240000 ticks = 4 in-game days, so 6.25/day per tile at 500W.
             Scale by building more; the reactor is 1x1 on purpose. -->
        <spawnIntervalRange><min>240000</min><max>240000</max></spawnIntervalRange>
        <requiresPower>true</requiresPower>
        <writeTimeLeftToSpawn>true</writeTimeLeftToSpawn>
        <!-- Pauses a reactor whose output nobody is hauling, so a sixteen-tile
             farm cannot carpet its room. Drop this if the pause proves more
             irritating than the pile. -->
        <spawnMaxAdjacent>150</spawnMaxAdjacent>
      </li>
    </comps>
  </ThingDef>

</Defs>
```

- [ ] **Step 4: Run and watch four pass**

Run: `bats tests/glittermatter-defs.bats`
Expected: `4 tests, 0 failures`.

- [ ] **Step 5: Validate and commit**

```bash
make check
git add tests/glittermatter-defs.bats mods/Glittermatter/Common/Defs/ThingDefs_Buildings/MatterReactor.xml
git commit -m "feat(glittermatter): add the matter reactor"
```

### Task 7: Trader availability

**Files:**
- Create: `mods/Glittermatter/Common/Patches/TraderKinds_MatterReactor.xml`

- [ ] **Step 1: Write the patch**

```xml
<?xml version="1.0" encoding="utf-8"?>
<Patch>

  <!-- Follows the vanilla Telescope pattern: a StockGenerator_SingleDef with
       countRange 0~1 on exotic traders only. Deliberately not on
       Base_Outlander_Standard — a reactor is exotic stock, not general goods. -->

  <Operation Class="PatchOperationAdd">
    <xpath>/Defs/TraderKindDef[defName="Orbital_Exotic"]/stockGenerators</xpath>
    <value>
      <li Class="StockGenerator_SingleDef">
        <thingDef>MatterReactor</thingDef>
        <countRange>0~1</countRange>
      </li>
    </value>
  </Operation>

  <Operation Class="PatchOperationAdd">
    <xpath>/Defs/TraderKindDef[defName="Caravan_Outlander_Exotic"]/stockGenerators</xpath>
    <value>
      <li Class="StockGenerator_SingleDef">
        <thingDef>MatterReactor</thingDef>
        <countRange>0~1</countRange>
      </li>
    </value>
  </Operation>

</Patch>
```

- [ ] **Step 2: Validate**

Run: `make check`
Expected: `XML OK`.

`make check` only proves the patch file parses. A patch whose xpath matches
nothing fails **silently at load** — RimWorld logs it but does not crash. Step
3 of Task 8 is the only real check.

- [ ] **Step 3: Commit**

```bash
git add mods/Glittermatter/Common/Patches/TraderKinds_MatterReactor.xml
git commit -m "feat(glittermatter): stock matter reactors with exotic traders"
```

### Task 8: In-game acceptance — the whole mod

- [ ] **Step 1: Restart RimWorld, dev mode on**

- [ ] **Step 2: Confirm the patch applied**

Search `Player.log` for patch errors:

```bash
grep -i "patch\|xpath" ~/.config/unity3d/Ludeon\ Studios/RimWorld\ by\ Ludeon\ Studios/Player.log | grep -i "glittermatter\|failed" | head
```

Expected: nothing. A failed xpath logs "Could not find a node matching" and is
otherwise invisible.

- [ ] **Step 3: Confirm a reactor is buyable**

Dev mode → *Execute command* → spawn an `Orbital_Exotic` trade ship, then open
trade.
Expected: a matter reactor sometimes appears in stock. `countRange 0~1` means
not every time — check two or three ships before concluding it is broken.

- [ ] **Step 4: Confirm the techprint is obtainable**

Trade with an Outlander caravan or base.
Expected: a "glittermatter adaptation techprint" appears in stock.

- [ ] **Step 5: Confirm the research gate**

Open the research tab.
Expected: *glittermatter adaptation* is listed, shows it needs 1 techprint, and
cannot be started until one is in a stockpile.

- [ ] **Step 6: Confirm the bootstrap rule**

With the research complete but no glittermatter in the colony, open Architect →
Production.
Expected: the matter reactor is visible but unbuildable for want of
glittermatter.

- [ ] **Step 7: Confirm production**

Dev-spawn a reactor, connect power, then dev-mode advance time ~4 days.
Expected: 500 W draw, an on-screen countdown from `writeTimeLeftToSpawn`, and
25 glittermatter produced.

- [ ] **Step 8: Confirm glittermatter never appears in generated goods**

Spawn several traders of different kinds and inspect their stock; check a raider
corpse's gear.
Expected: no glittermatter items anywhere.

This is the check most likely to be quietly wrong and least likely to be
noticed by playing normally. Do it deliberately.

- [ ] **Step 9: Check the log**

Expected: no red errors mentioning Glittermatter, MatterReactor, or
GlittermatterAdaptation.

---

## Chunk 3: Documentation and release

### Task 9: Update the mod docs

**Files:**
- Modify: `mods/Glittermatter/README.md`
- Modify: `CHANGELOG.md`
- Modify: `BACKLOG.md`

- [ ] **Step 1: Update the mod README**

Change the status line from "outline" to reflect that the material and reactor
exist. Mark stages 1–2 of the roadmap done. Move "fast to make" out of the
material and into the future workbench row. Update the component table so
Matter Reactor reads XML/done.

- [ ] **Step 2: Add a CHANGELOG entry**

Under `## [Unreleased]` → `### Added`: the glittermatter material, the matter
reactor, techprint-gated adaptation research, and exotic-trader availability.

- [ ] **Step 3: Add BACKLOG entries**

- **Glittermatter should not be recoverable when deconstructed** — all stored
  energy is spent hardening it in place, so there is nothing left to reclaim.
  Needs a Harmony patch on `RimWorld.GenLeaving`;
  `resourcesFractionWhenDeconstructed` lives on `BuildableDef` and
  `StuffProperties` has no per-stuff equivalent. Requires a .NET SDK, which is
  not installed.
- **Real textures** — placeholders at
  `mods/Glittermatter/Common/Textures/**` are generated and untracked. A
  cloner sees missing-texture errors. Must be closed before publishing.
- **Reactor balance** — output rate, power draw and build cost are all
  first-pass; they need play testing rather than arithmetic.

- [ ] **Step 4: Commit**

```bash
git add mods/Glittermatter/README.md CHANGELOG.md BACKLOG.md
git commit -m "docs(glittermatter): record v1 content and deferred work"
```

### Task 10: Open the pull request

- [ ] **Step 1: Final checks**

```bash
make check && make test
grep -rniF -e "$HOME" -e "$(git config --global user.name)" . --exclude-dir=.git || echo clean
git status --porcelain
```
Expected: checks pass; `clean`; and the **only** entry in `git status` is the
untracked `mods/Glittermatter/Common/Textures/` directory.

- [ ] **Step 2: Push and open a draft PR**

```bash
git push -u origin feat/glittermatter-material
gh pr create --draft \
  --title "feat(glittermatter): the material and the matter reactor" \
  --body "..."
```

Draft is the creation state. Flip to ready with `gh pr ready` once the in-game
acceptance checks in Task 8 have actually been run and reported.
