# Support weapons

Machine guns that are good at being machine guns, paid for in positional commitment rather than in bad shooting.

Not part of Glittermatter. This changes how vanilla weapons behave, needs C# and Harmony, and would stand on its own —
Glittermatter's LMG line would simply benefit from it if both are installed.

## The problem

RimWorld's LMG is disappointing, and the reason is not that machine guns are bad. It is that the game omits nearly every
reason a machine gun is inconvenient:

- weight and bulk;
- how badly it shoots unsupported;
- setup and repositioning time;
- awkwardness at close range;
- the ammunition burden;
- the tactical commitment of establishing a firing position.

A pawn carries an LMG around exactly as freely as an assault rifle. If the LMG then had the firepower the name promises,
there would be no reason ever to carry anything else. So vanilla balances it the only way left open: **by weakening the
thing it is supposed to be good at.**

The fix is to put the drawbacks back where they belong, and then stop apologising for the gun.

> Move the balance cost out of artificially poor shooting and into tactical commitment.

## The three classes

The real line is blurred, and where it is sharp it is about crews. An LMG gunner moves with the rifle element and works
the gun alone. An MMG's full capability comes from a crew, an ammunition supply, a tripod and barrel management. An HMG
is crew-served and effectively emplacement- or vehicle-dependent.

RimWorld is not getting a crewing requirement — one pawn operates everything — so the distinction has to be drawn
somewhere a single gunner can feel it. Draw it at what the gunner brought.

| Class   | Configuration                                                          | Round        | Answers                 |
| ------- | ---------------------------------------------------------------------- | ------------ | ----------------------- |
| **LMG** | Light and movable, some of which is simply carrying less ammunition    | 5.56         | There are a lot of them |
| **MMG** | Can be the same gun: tripod, spare barrels, three times the ammunition | 5.56 or 7.62 | They are still coming   |
| **HMG** | Heavy, emplaced                                                        | 12.7         | It is armoured          |

The useful part is that an MMG can be **the same model of weapon** as the LMG. What makes it one is the tripod, the
barrels to swap when the first is spent, and enough ammunition to justify swapping them. That is also why it cannot fire
unsupported: the configuration is the support.

None of the kit is a mechanic. Vanilla has no ammunition system and is not getting one here, so spare barrels and three
times the ammunition are the justification for the numbers rather than things to track — they cash out as burst length
and cooldown in the table below.

Calibre is a second axis and it is not locked to the first. An MMG may step up to the heavier rifle round rather than
just carry more of the light one. The HMG's 12.7 is where it stops being an infantry weapon at all — effective against
light vehicles, which here means mechanoids and power armour, so its identity is armour penetration rather than more of
the same damage.

## The three states

Unsupported, braced, deployed — and each class up the ladder loses the least committed one.

| Class   | Unsupported | Braced | Deployed |
| ------- | ----------- | ------ | -------- |
| **LMG** | Yes         | Yes    | Yes      |
| **MMG** | No          | Yes    | Yes      |
| **HMG** | No          | No     | Yes      |

Cut one freedom per level. The LMG stays genuinely portable and can be fired standing in the open, just not to its full
effect. The MMG needs something to brace against — mobile around a prepared position, not shouldered in a field. The HMG
is crew-served in spirit even though RimWorld will show one pawn operating it: **deploy it or do not fire it.**

## What the states buy

Not accuracy. For the LMG the difference is how much sustained fire the pawn can actually deliver:

| State           | Effect                                                            |
| --------------- | ----------------------------------------------------------------- |
| **Unsupported** | Roughly current performance, but a shorter burst                  |
| **Braced**      | Vanilla-length burst, somewhat shorter cooldown                   |
| **Deployed**    | Substantially longer burst, much shorter cooldown, reduced warmup |

Deploying does not make the bullets straighter. It lets the pawn operate the weapon as a machine gun. That is the niche
the assault rifle cannot take:

> **Assault rifle:** general-purpose mobile infantry weapon. **LMG:** there are a lot of them.

## Bracing

Bracing needs real target-relative cover, not a check for whether the pawn happens to be standing next to a wall. If the
shot passes across an adjacent piece of suitable cover, the weapon can use it as a support.

The point is that ordinary RimWorld defensive building already produces good firing positions. No bipod-placement
minigame, no new thing to fiddle with — the sandbags a player already puts down start meaning more.

## Deployment

The stronger mechanic of the two, and an explicit command:

- takes time;
- the pawn becomes fixed in position;
- a slight cover bonus, stacking with ordinary cover;
- the weapon gets its unrestricted performance;
- the pawn cannot simply walk away.

Leaving takes one of two decisions. **Pack up**, which takes time. Or **abandon the weapon**, which is immediate.

The second is the interesting one, because it makes overrunning a gun position a real event. When a scyther arrives on
top of an HMG gunner, nobody waits politely while the tripod is folded. Leave the gun and run.

## Rejected: facing and firing arcs

The obvious next step is limited traverse on a deployed weapon, and it is wrong — not for realism reasons but for AI
reasons. Vanilla enemies will not recognise a firing arc and flank it. Arcs would therefore be pure player
micromanagement that buys no interesting enemy behaviour.

**Minimum effective range does the same job for free.** Short-range accuracy should be poor, and worse the heavier the
weapon, because bringing something that size onto a close moving target is slow. Vanilla AI then produces the desired
behaviour without knowing it is doing so:

> Enemy closes distance → the heavy weapon becomes progressively less suitable.

`VerbProperties` already carries `minRange`, so this part may need no code at all.

## Then the HMG is allowed to be frightening

Once a weapon has mandatory deployment, setup and pack-up time, no movement while firing, terrible close-range handling,
and serious vulnerability to being overrun, there is nothing left to apologise for. A properly deployed HMG **should be
considerably nastier than an assault rifle**. That is what all those constraints were purchased with.

The MMG then sits genuinely between the two, rather than being another gun with slightly different damage per second.

## Sidearms fall out of it

A deployed HMG operator has an excellent reason to carry an autopistol: abandon the gun, draw the pistol, run or fight.

Not a general sidearm system — nobody should carry a charge rifle plus a second charge rifle. Heavy weapons specifically
permit a small sidearm class, which finally gives handguns one of their real advantages back. Glittermatter solves the
same handgun problem from the other end, with a movement bonus; the two are compatible and neither needs the other.

## The ladder

| Weapon            | What it is                                                                    |
| ----------------- | ----------------------------------------------------------------------------- |
| **Assault rifle** | Mobile generalist                                                             |
| **LMG**           | Mobile support weapon, increasingly effective braced and deployed             |
| **MMG**           | Support weapon wanting a prepared position, or at least something to brace on |
| **HMG**           | Stationary weapon you can carry somewhere else; once deployed, answers armour |

The same trade — more firepower bought with more positional commitment — extends to the other family this came with:
anti-materiel rifles, in light, medium and heavy.

## Status

A second mod, rebalancing the LMG family. Not scaffolded under `mods/` yet and not named — it arrived during a
Glittermatter brainstorm, and it is written down here so it stops being Glittermatter's problem.

It needs C#, Harmony and a .NET SDK, none of which is installed, so nothing about it is close to buildable. `minRange`
is the one piece that already exists.
