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
