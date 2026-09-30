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

Precision ≈ Excellent+. This came out of looking at the actual vanilla quality scaling. Excellent ranged weapons aren't
enormously better overall because their quality modifier primarily gives them 120% accuracy, while ranged damage and AP
remain at 100%. There is a big jump to Masterwork.

And importantly, not Legendary. Legendary remains something genuinely exceptional that the deterministic fabrication
system doesn't casually reproduce.

The naming of the tiers also has a theme, and the theme is how generic a name is allowed to be. Standard weapons are
fully generic: some variation on Matter `<gun>`. Precision weapons are somewhat generic — named for the technology or
the _one obvious_ feature, the way a catalogue names things. Master Pattern weapons are given fanciful names of legend,
by a dedicated marketing team that spent three months deciding.

The Thumper is the exception. Officially it is a HESH launcher; it is called the Thumper because nobody knows what HESH
is and it goes thump.

### Manufacturing costs

Generally replace the steel price of the vanilla counterpart with glittermatter; Precision and Master can require more
specialised material. Component cost is unchanged; and of course the work required is _very_ low. If the materials are
next to the workbench, it is reasonable to make the weapon you need while raiders are attacking the door.

## The lines

First the targeted vanilla niches, with the weapon that represents each one and gives the line its name.

| #  | Line           | Vanilla weapon    | Basic niche                  | What distinguishes it                                                                                  |
| -- | -------------- | ----------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------ |
| 1  | Knife          | Knife             | Fast mêlée                   | Low commitment, quick attacks; basic close-combat weapon                                               |
| 2  | Sword          | Sword             | Heavy mêlée                  | More decisive mêlée attacks; trades speed/cost for greater effectiveness                               |
| 3  | Autopistol     | Autopistol        | Light handgun                | Quick, handy, short-range general-purpose sidearm                                                      |
| 4  | Revolver       | Revolver          | Heavy handgun                | Slower but harder-hitting pistol; more emphasis on individual shots                                    |
| 5  | Machine pistol | Machine pistol    | Light automatic              | Very short-range volume of fire; pistol-sized automatic weapon                                         |
| 6  | Heavy SMG      | Heavy SMG         | Heavy close-range automatic  | Powerful, accurate short/medium-range automatic fire; excellent general combat weapon inside its range |
| 7  | Shotgun        | Pump shotgun      | Close-range stopping power   | Deliberate, extremely powerful close-range attacks against individual targets                          |
| 8  | Chain shotgun  | Chain shotgun     | Close-range volume           | Trades reach for enormous short-range damage output; handles multiple/rapid targets better than pump   |
| 9  | Assault rifle  | Assault rifle     | General-purpose rifle        | Good range, accuracy and automatic fire; deliberately broad applicability                              |
| 10 | LMG            | LMG               | Sustained rifle-calibre fire | Volume of fire at useful rifle ranges; built to reward bracing and deployment                          |
| 11 | DMR            | Bolt-action rifle | General long-range rifle     | Accurate, powerful long-range shots without the extreme specialisation of a sniper rifle               |
| 12 | Sniper         | Sniper rifle      | Extreme precision/range      | Maximum ability to hit difficult targets at long distance, paid for with low rate of fire              |

Line names default to the vanilla reference and are expected to drift off it — line 7 is the shotgun line and contains
exactly one shotgun glittermatter weapon, and line 11 is named for the job rather than for the bolt it no longer has.

An alternate view of the same idea:

|                 | **Lighter / faster / broader** | **Heavier / more specialised** |
| --------------- | ------------------------------ | ------------------------------ |
| Mêlée           | Knife                          | Sword                          |
| Handgun         | Autopistol                     | Revolver                       |
| Short automatic | Machine pistol                 | Heavy SMG                      |
| Close stopping  | Pump shotgun                   | Chain shotgun                  |
| Rifle automatic | Assault rifle                  | LMG                            |
| Rifle precision | Bolt-action                    | Sniper rifle                   |

Handguns are not really viable in vanilla, the drawbacks of carrying around an assault rifle all the time aren't really
represented. To give _some_ reason for them to exist, they give a modest boost to movement speed, the inverse of heavier
weapons.

Ideally that would be a lack of a penalty instead; but I'm not reworking all of vanilla just to support one idea. I
considered giving a similar speed boost to mêlée, but no. It gives handguns a specialised niche: being able to run away
from mêlée combatants.

## Line 1 — Knife

**Niche: fast mêlée.** Low commitment and quick attacks. The line remains the weapon for getting repeated attacks in
rather than winning through one enormous hit.

| Pattern   | Weapon       | Character                                                                 |
| --------- | ------------ | ------------------------------------------------------------------------- |
| Standard  | Matter knife | Cheap, standardised matterformed knife; approximately the vanilla niche.  |
| Precision | Plasedge     | Glittermatter body with a small plasteel edge; fast, precise and vicious. |
| Master    |              |                                                                           |

### Matter knife

The basic matterformed knife. No Stuff variation and no quality roll: the fabrication program produces the same weapon
every time.

Technically the _only_ input to the fabrication is energy, since a knife is all steel, so it only costs glittermatter —
which could be an advantage in itself.

### Plasedge

A fixed composite design rather than a Stuff weapon. Glittermatter supplies the structure and a small amount of plasteel
is concentrated where it matters: the edge. Its performance budget leans into attack speed as well as damage/AP.

## Line 2 — Sword

**Niche: heavy mêlée.** More decisive individual attacks than the knife line, with greater commitment between attacks.

| Pattern   | Weapon       | Character                                                                           |
| --------- | ------------ | ----------------------------------------------------------------------------------- |
| Standard  | Matter sword | Standardised matterformed sword; straightforward heavy mêlée.                       |
| Precision | Plasfoil     | Extremely light composite sword with a plasteel edge; speed without giving up bite. |
| Master    |              |                                                                                     |

### Matter sword

The basic fixed-pattern sword: cheap, fast to fabricate and deliberately unremarkable.

### Plasfoil

Glittermatter makes it possible to put material only where the structure needs it, producing a very light blade with a
small amount of plasteel concentrated at the edge. It distinguishes itself through unusually quick recovery for a sword
and high AP.

## Line 3 — Autopistol

**Niche: mobility and reaction.** A light handgun is something a pawn can carry without paying the mobility cost of a
full-sized weapon. It is not intended to beat rifles in a straight firefight.

However, since RimWorld doesn't have a general move penalty for being armed, this is a slight bonus instead. Gameplay
over realism.

| Pattern   | Weapon                | Character                                                                     |
| --------- | --------------------- | ----------------------------------------------------------------------------- |
| Standard  | Matter autopistol     | Cheap light handgun; quick handling and no movement penalty.                  |
| Precision | Electrothermal pistol | Electrically vaporises an inert propellant for consistent, controllable fire. |
| Master    |                       |                                                                               |

### Matter autopistol

The basic sidearm idea stated plainly: light, quick and cheap. Its principal advantage is that carrying it does not slow
the pawn down. In a fair fight, pistol beats mêlée.

### Electrothermal pistol

Electrical energy vaporises an inert working fluid or propellant to launch the projectile. The technology is used for
consistency and handling rather than turning a pistol into a rifle: quick warmup, quick follow-up shots and good
short-range performance.

## Line 4 — Revolver

**Niche: heavy handgun.** Preserve handgun mobility while putting disproportionate power into individual shots.

| Pattern   | Weapon            | Character                                                                       |
| --------- | ----------------- | ------------------------------------------------------------------------------- |
| Standard  | Matter revolver   | Simple heavy sidearm; slower but harder hitting than the autopistol line.       |
| Precision | EM-boosted pistol | Deliberately excessive hand cannon; electromagnetic assistance boosts the shot. |
| Master    |                   |                                                                                 |

### Matter revolver

A conventional matterformed heavy pistol. It gives up rate of fire for stronger individual shots while retaining the
mobility advantage of the handgun class.

### EM-boosted pistol

A somewhat ridiculous Desert-Eagle-like solution: conventional propulsion gets electromagnetic assistance. High damage
and penetration for a handgun, paid for in cadence and handling rather than by pretending it is a general-purpose rifle.

## Line 5 — Machine pistol

**Niche: very short-range volume of fire.** The light automatic: compact, fast and intended to put many small
projectiles into a nearby target.

| Pattern   | Weapon                | Character                                                        |
| --------- | --------------------- | ---------------------------------------------------------------- |
| Standard  | Matter machine pistol | Cheap compact automatic weapon.                                  |
| Precision | Fléchette pistol      | Fully automatic pistol firing large numbers of small flechettes. |
| Master    |                       |                                                                  |

### Matter machine pistol

The vanilla idea reproduced cheaply: a compact automatic weapon whose advantage is volume rather than reach or
individual shot power.

### Fléchette pistol

A high-rate automatic firing small fléchettes. It leans harder into the machine-pistol niche: lots of ammunition and
lots of projectiles at very short range, without trying to become a Heavy SMG.

## Line 6 — Heavy SMG

**Niche: heavy close-range automatic.** A genuinely good primary weapon inside its range: more substantial than the
machine-pistol line, but still giving up rifle reach.

| Pattern   | Weapon     | Character                                                                        |
| --------- | ---------- | -------------------------------------------------------------------------------- |
| Standard  | Matter SMG | Straightforward matterformed heavy SMG.                                          |
| Precision | Sabot SMG  | Heavy pistol rounds carrying saboted penetrators; trades some raw damage for AP. |
| Master    |            |                                                                                  |

### Matter SMG

Vanilla's "heavy" distinguishes it from nothing — the light SMG is the machine pistol — so the matter version drops the
qualifier.

The vanilla niche without embellishment: strong automatic fire at short to medium range, fabricated cheaply and
consistently.

### Sabot SMG

Fires heavy pistol-calibre cartridges containing smaller saboted penetrators. Compared with the vanilla Heavy SMG, its
identity leans away from raw damage and toward armour penetration while remaining unmistakably an SMG.

## Line 7 — Shotgun

**Niche: short-range stopping power.** Somewhat unfilled in vanilla, this leans into the anti-mech side of weaponry.

| Pattern   | Weapon         | Character                                                                 |
| --------- | -------------- | ------------------------------------------------------------------------- |
| Standard  | Matter shotgun | Conventional matterformed shotgun.                                        |
| Precision | Thumper        | Large-bore HESH weapon; short-range, enormous blunt alpha strike.         |
| Master    | Prayer         | Bespoke close-range solution to things you desperately do not want close. |

### Matter shotgun

Pistol grip, roughly a SPAS-12. The niche stated plainly and made cheaply. A little stronger than a pump shotgun, as
that is one of the weak vanilla weapons. Given the rest of the line, this is probably by giving it AP.

### Thumper

Officially a HESH launcher. Closer to an M79, built around short-range HESH. Not a shotgun any more — the line is named
for where it started, not for what it holds.

### Prayer

A revolver grenade launcher firing explosive nets. Massively complex to get right: an explosive net tangled in the
cylinder is the obvious failure and the whole engineering problem. But when a scyther is at near-mêlée range, all you
have is a Prayer.

## Line 8 — Chain shotgun

**Niche: close-range volume.** Where the shotgun line solves one nearby problem decisively, this line solves the problem
that there are several of them.

| Pattern   | Weapon               | Character                                                               |
| --------- | -------------------- | ----------------------------------------------------------------------- |
| Standard  | Matter chain shotgun | Cheap matterformed version of the vanilla close-range bullet hose.      |
| Precision | Storm gun            | Stacked-projectile weapon with absurd instantaneous close-range output. |
| Master    |                      |                                                                         |

### Matter chain shotgun

A conventional matterformed chain shotgun, with the usual short range and enormous close-range output.

### Storm gun

Inspired by stacked-projectile / Metal-Storm-like concepts: multiple projectiles are loaded in the barrel and fired
electronically at an absurd instantaneous rate. It delivers a terrifying burst and pays for it with substantial
downtime. Unlike the Thumper, this is explicitly the weapon for volume.

## Line 9 — Assault rifle

**Niche: general-purpose rifle.** The deliberately broad weapon: useful range, accuracy and automatic fire without
dominating a specialised weapon inside its speciality.

| Pattern   | Weapon               | Character                                                          |
| --------- | -------------------- | ------------------------------------------------------------------ |
| Standard  | Matter assault rifle | Straightforward general-purpose matterformed rifle.                |
| Precision | LP assault rifle     | Liquid-propellant rifle; controlled, tunable general-purpose fire. |
| Master    |                      |                                                                    |

### Matter assault rifle

The boring answer is intentional: a cheap, deterministic assault rifle that is good at most ordinary firefights and
exceptional at none of them.

### LP assault rifle

Short for liquid-propellant assault rifle, which is the whole of the name and meant to be.

Uses liquid propellant, allowing the weapon to meter the charge rather than accepting a fixed cartridge load. The
technology serves the assault-rifle niche rather than creating a gimmick: reliable, controllable general-purpose
performance.

## Line 10 — LMG

**Niche: sustained rifle-calibre fire.** The answer to "there are a lot of them": longer-ranged and more sustained than
the close-range volume weapons.

| Pattern   | Weapon       | Character                                                                 |
| --------- | ------------ | ------------------------------------------------------------------------- |
| Standard  | Matter LMG   | Cheap conventional light machine gun.                                     |
| Precision | Mini-Gatling | Compact rotary rifle-calibre weapon built for sustained high-volume fire. |
| Master    |              |                                                                           |

### Matter LMG

A conventional matterformed LMG. The long-term design intends LMGs to benefit from bracing/deployment, but that mechanic
requires code and is not necessary to define the weapon line.

### Mini-Gatling

A compact multi-barrel weapon firing rifle ammunition. It is deliberately distinct from the Storm gun: the Storm
produces an absurd instantaneous close-range burst; the Mini-Gatling provides sustained volume at useful rifle ranges.

## Line 11 — DMR

**Niche: general long-range rifle.** Accurate and powerful at range, but not the extreme specialist represented by the
sniper line.

| Pattern   | Weapon      | Character                                                                                   |
| --------- | ----------- | ------------------------------------------------------------------------------------------- |
| Standard  | Matter DMR  | Straightforward matterformed long-range rifle.                                              |
| Precision | Smart rifle | Packed with electronics and control systems for accurate, reasonably quick long-range fire. |
| Master    |             |                                                                                             |

### Matter DMR

A cheap fixed-pattern version of the vanilla long-range general-purpose rifle.

### Smart rifle

Packed with sensors, electronics and assorted widgets to improve precision and firing cadence at long range. It does not
have the sniper rifle's extensive targeting specialisation and does not try to match an assault rifle's rapid fire.

## Line 12 — Sniper

**Niche: extreme precision and range.** The weapon for the particular difficult target over there that needs shooting.

| Pattern   | Weapon              | Character                                                |
| --------- | ------------------- | -------------------------------------------------------- |
| Standard  | Matter sniper rifle | Conventional matterformed sniper rifle.                  |
| Precision | Beamrider rifle     | Laser-guided in-flight correction for extreme precision. |
| Master    |                     |                                                          |

### Matter sniper rifle

The standard sniper niche produced cheaply and deterministically: long range, high precision and a low rate of fire.

### Beamrider rifle

The rifle fires a laser at its own projectile. Selective heating or ablation steers the projectile in flight while the
weapon's electronics track both projectile and target. The shooter still aims at the target; the correction system makes
that difficult long-range shot substantially less difficult.

## Out of scope

The patterns multiply by tech level as well — industrial and spacer — but vanilla puts only the charge rifle on the
spacer tier, so there is no full set of references to fill. That axis is a submod, not part of this tree.
