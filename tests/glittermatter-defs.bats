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

@test "the first reactor cannot be built" {
    # The cost list contains glittermatter, and reactors are its only source.
    # This one line is the entire bootstrap rule; without it the mod becomes
    # self-starting and nothing in play would look wrong.
    run xp 'count(/Defs/ThingDef[defName="MatterReactor"]/costList/Glittermatter)' "$BUILDINGS"
    [ "$output" = "1" ]
}
