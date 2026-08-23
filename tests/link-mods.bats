#!/usr/bin/env bats

setup() {
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    SCRIPT="$REPO_ROOT/bin/link-mods.sh"
    FIXTURE="$(mktemp -d)"
    mkdir -p "$FIXTURE/Mods"
    export RIMWORLD_DIR="$FIXTURE"
}

teardown() {
    rm -rf "$FIXTURE"
}

# Every directory under mods/. Asserting over these rather than naming
# Glittermatter keeps the tests correct as mods are added.
mod_names() {
    local source
    for source in "$REPO_ROOT"/mods/*/; do
        [[ -d $source ]] && basename "${source%/}"
    done
}

@test "creates a symlink for every mod" {
    run "$SCRIPT"
    [ "$status" -eq 0 ]

    for name in $(mod_names); do
        [ -L "$FIXTURE/Mods/$name" ]
        [ "$(readlink "$FIXTURE/Mods/$name")" = "$REPO_ROOT/mods/$name" ]
    done
}
