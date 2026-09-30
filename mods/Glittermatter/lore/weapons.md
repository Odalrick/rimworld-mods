# Weapons

What the Matter Fabricator makes. Every vanilla weapon occupies a niche; glittermatter fills that same niche three times
over, at rising cost and rising absurdity.

These are not better weapons. They are the same weapons, with craftsmanship replaced by technology.

## The three patterns

| Pattern       | Vibe      | What it is                                                                                                           |
| ------------- | --------- | -------------------------------------------------------------------------------------------------------------------- |
| **Standard**  | ordinary  | The normal weapon, matterformed in a specialised workbench, quickly and accurately. Cheap, printed, mass-producible. |
| **Precision** | upgraded  | The same niche, with the improvements glittermatter allows, aimed squarely at that niche.                            |
| **Master**    | excessive | The same niche again, with excessive technology invested in dominating it.                                           |

"Ordinary, upgraded, excessive" is the vibe, not the description. The pattern names are what the defs are called.

Mechanically the tiers replace quality rolls with fixed stats — see **Implementation notes** in `../README.md`, which
covers why they are separate ThingDefs with no `CompQuality`.

## The lines

One line per niche, three weapons per line. The niche column is the useful one: it says what the line is _for_, which is
what decides whether the Precision and Master entries are obvious or impossible.

| #  | Line           | Vanilla reference | Niche                      |
| -- | -------------- | ----------------- | -------------------------- |
| 1  | Knife          | Knife             |                            |
| 2  | Sword          | Sword             |                            |
| 3  | Autopistol     | Autopistol        |                            |
| 4  | Revolver       | Revolver          |                            |
| 5  | Machine pistol | Machine pistol    |                            |
| 6  | Heavy SMG      | Heavy SMG         |                            |
| 7  | Shotgun        | Pump shotgun      | Short-range stopping power |
| 8  | Chain shotgun  | Chain shotgun     |                            |
| 9  | Assault rifle  | Assault rifle     |                            |
| 10 | LMG            | LMG               |                            |
| 11 | Bolt-action    | Bolt-action rifle |                            |
| 12 | Sniper         | Sniper rifle      |                            |

Line names default to the vanilla reference and are expected to drift off it — line 7 is the shotgun line and contains
exactly one shotgun.

Thirty-six weapons will not fit in one grid and stay readable, so the grid stops here. Each line gets its own section
below, holding the three names and what each one actually is; the table above stays as the index. A line with nothing
written yet simply has no section.

## Line 7 — Shotgun

**Niche: short-range stopping power.** Somewhat unfilled in vanilla.

| Pattern   | Weapon         | Character                                                                 |
| --------- | -------------- | ------------------------------------------------------------------------- |
| Standard  | Matter shotgun | Conventional matterformed shotgun.                                        |
| Precision | Thumper        | Large-bore HESH weapon; short-range, enormous blunt alpha strike.         |
| Master    | Prayer         | Bespoke close-range solution to things you desperately do not want close. |

**Matter shotgun.** Pistol grip, roughly a SPAS-12. The niche stated plainly and made cheaply.

**Thumper.** Closer to an M79, built around short-range HESH. Not a shotgun any more — the line is named for where it
started, not for what it holds.

**Prayer.** A revolver grenade launcher firing explosive nets. Massively complex to get right: an explosive net tangled
in the cylinder is the obvious failure and the whole engineering problem. But when a scyther is at near-melee range, all
you have is a Prayer.

## Out of scope

The patterns multiply by tech level as well — industrial and spacer — but vanilla puts only the charge rifle on the
spacer tier, so there is no full set of references to fill. That axis is a submod, not part of this tree.

`../README.md` already asks which weapons are actually worth fabricating. Thirty-six ThingDefs is the upper bound, not a
plan.
