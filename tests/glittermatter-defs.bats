#!/usr/bin/env bats
#
# Guards the def properties whose breakage is invisible during play.
# Balance numbers are deliberately NOT asserted here — they are meant to change.

setup() {
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    DEFS="$REPO_ROOT/mods/Glittermatter/Common/Defs"
    ITEMS="$DEFS/ThingDefs_Items/Glittermatter.xml"
    BUILDINGS="$DEFS/ThingDefs_Buildings/MatterReactor.xml"
}

# Evaluate an XPath expression against a def file.
xp() {
    xmllint --xpath "$1" "$2" 2>/dev/null
}

@test "glittermatter cannot be traded" {
    run xp 'string(/Defs/ThingDef[defName="Glittermatter_Raw"]/tradeability)' "$ITEMS"
    [ "$output" = "None" ]
}

@test "glittermatter is excluded from generated items" {
    run xp 'string(/Defs/ThingDef[defName="Glittermatter_Raw"]/stuffProps/allowedInStuffGeneration)' "$ITEMS"
    [ "$output" = "false" ]
}

@test "glittermatter serves all three rigid stuff categories" {
    local cat
    for cat in Woody Stony Metallic; do
        run xp "count(/Defs/ThingDef[defName=\"Glittermatter_Raw\"]/stuffProps/categories/li[text()=\"$cat\"])" "$ITEMS"
        [ "$output" = "1" ]
    done
}

@test "the first reactor cannot be built" {
    # The cost list contains glittermatter, and reactors are its only source.
    # This one line is the entire bootstrap rule; without it the mod becomes
    # self-starting and nothing in play would look wrong.
    run xp 'count(/Defs/ThingDef[defName="Glittermatter_Reactor"]/costList/Glittermatter_Raw)' "$BUILDINGS"
    [ "$output" = "1" ]
}

@test "every texPath is namespaced to the mod" {
    # ContentFinder resolves a texPath across every active mod, not within the
    # owning one, and says so when it fails: "in any active mod or in base
    # resources". Two mods shipping Things/Building/MatterReactor.png means load
    # order picks the winner, and nothing warns — so the mod name goes first.
    local count
    count=$(grep -rho '<texPath>' "$DEFS" | wc -l)
    [ "$count" -ge 2 ]

    local path
    while read -r path; do
        [[ "$path" == Glittermatter/* ]]
    done < <(grep -rho '<texPath>[^<]*</texPath>' "$DEFS" | sed -e 's|</\?texPath>||g')
}
