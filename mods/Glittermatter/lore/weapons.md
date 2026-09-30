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

| Pattern       | Approx. vanilla quality equivalent   | Intent                                                                |
| ------------- | ------------------------------------ | --------------------------------------------------------------------- |
| **Standard**  | **Normal**                           | Cheap, deterministic mass production                                  |
| **Precision** | **Between Excellent and Masterwork** | Clearly superior engineered weapon, but not yet Masterwork-equivalent |
| **Master**    | **About Masterwork**                 | Technology substitutes for exceptional craftsmanship                  |

This is however more of a power budget, quality is very standard in what it affects; matter weapons distribute that
power to get at the niche more directly. And there are a few weapons that are underpowered, "unusable" at the standard
level; those get a boost to where I think they could be so that they are a choice and not just dominated by another
weapon.

Precision ≈ Excellent+ This came out of looking at the actual vanilla quality scaling. Excellent ranged weapons aren't
enormously better overall because their quality modifier primarily gives them 120% accuracy, while ranged damage and AP
remain at 100%. There is a big jump to Masterwork.

And importantly, not Legendary. Legendary remains something genuinely exceptional that the deterministic fabrication
system doesn't casually reproduce.

The naming of the tiers also have a theme; Standard weapons are generally just some variation on Matter <gun> .
Precision are more about describing the technology, or the _one obvious_ feature; and Master Pattern weapons are given
fanciful names of legend.

## The lines

First the targeted vanilla niches, with the weapon that represents that niche, and names the line.

| #  | Line           | Vanilla weapon    | Basic niche                  | What distinguishes it                                                                                  |
| -- | -------------- | ----------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------ |
| 1  | Knife          | Knife             | Fast melee                   | Low commitment, quick attacks; basic close-combat weapon                                               |
| 2  | Sword          | Sword             | Heavy melee                  | More decisive melee attacks; trades speed/cost for greater effectiveness                               |
| 3  | Autopistol     | Autopistol        | Light handgun                | Quick, handy, short-range general-purpose sidearm                                                      |
| 4  | Revolver       | Revolver          | Heavy handgun                | Slower but harder-hitting pistol; more emphasis on individual shots                                    |
| 5  | Machine pistol | Machine pistol    | Light automatic              | Very short-range volume of fire; pistol-sized automatic weapon                                         |
| 6  | Heavy SMG      | Heavy SMG         | Heavy close-range automatic  | Powerful, accurate short/medium-range automatic fire; excellent general combat weapon inside its range |
| 7  | Shotgun        | Pump shotgun      | Close-range stopping power   | Deliberate, extremely powerful close-range attacks against individual targets                          |
| 8  | Chain shotgun  | Chain shotgun     | Close-range volume           | Trades reach for enormous short-range damage output; handles multiple/rapid targets better than pump   |
| 9  | Assault rifle  | Assault rifle     | General-purpose rifle        | Good range, accuracy and automatic fire; deliberately broad applicability                              |
| 10 | LMG            | LMG               | Sustained rifle-calibre fire | Volume of fire at useful rifle ranges; should reward prepared/braced/deployed use in our redesign      |
| 11 | Bolt-action    | Bolt-action rifle | General long-range rifle     | Accurate, powerful long-range shots without the extreme specialization of a sniper rifle               |
| 12 | Sniper         | Sniper rifle      | Extreme precision/range      | Maximum ability to hit difficult targets at long distance, paid for with low rate of fire              |

Line names default to the vanilla reference and are expected to drift off it — line 7 is the shotgun line and contains
exactly one shotgun glittermatter weapon.

An alternate view of the same idea:

|                 | **Lighter / faster / broader** | **Heavier / more specialized** |
| --------------- | ------------------------------ | ------------------------------ |
| Melee           | Knife                          | Sword                          |
| Handgun         | Autopistol                     | Revolver                       |
| Short automatic | Machine pistol                 | Heavy SMG                      |
| Close stopping  | Pump shotgun                   | Chain shotgun*                 |
| Rifle automatic | Assault rifle                  | LMG                            |
| Rifle precision | Bolt-action                    | Sniper rifle                   |

Handguns are not really viable in vanilla, the drawbacks of carrying around an assault rifle all the time aren't really
represented. To give _some_ reason for them to exists, they give a modest boost to movement speed, the inverse of
heavier weapons.

Ideally that would be a lack of a penalty instead; but I'm not reworking all of vanilla just to support one idea. I
considered giving a similar speed boost to melee, but no. It gives handguns a specialised niche: being able to run away
from melee combatants.

## Line 1 — Knife

## Line 2 — Sword

## Line 3 — Autopistol

## Line 4 — Revolver

## Line 5 — Machine pistol

## Line 6 — Heavy SMG

## Line 7 — Shotgun

**Niche: short-range stopping power.** Somewhat unfilled in vanilla.

| Pattern   | Weapon         | Character                                                                 |
| --------- | -------------- | ------------------------------------------------------------------------- |
| Standard  | Matter shotgun | Conventional matterformed shotgun.                                        |
| Precision | Thumper        | Large-bore HESH weapon; short-range, enormous blunt alpha strike.         |
| Master    | Prayer         | Bespoke close-range solution to things you desperately do not want close. |

### Matter shotgun.

Pistol grip, roughly a SPAS-12. The niche stated plainly and made cheaply. A little stronger than a pump shotgun, as
that is one of the weak vanilla weapons. Given the rest of the line, this is probably by giving it AP.

### Thumper

Closer to an M79, built around short-range HESH. Not a shotgun any more — the line is named for where it started, not
for what it holds.

### Prayer

A revolver grenade launcher firing explosive nets. Massively complex to get right: an explosive net tangled in the
cylinder is the obvious failure and the whole engineering problem. But when a scyther is at near-melee range, all you
have is a Prayer.

## Line 8 — Chain shotgun

## Line 9 — Assault rifle

## Line 10 — LMG

## Line 11 — Bolt-action

## Line 12 — Sniper

## Out of scope

The patterns multiply by tech level as well — industrial and spacer — but vanilla puts only the charge rifle on the
spacer tier, so there is no full set of references to fill. That axis is a submod, not part of this tree.
