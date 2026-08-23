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

@test "is idempotent" {
    local before after
    before="$(find "$REPO_ROOT/mods" | sort)"

    run "$SCRIPT"
    [ "$status" -eq 0 ]

    run "$SCRIPT"
    [ "$status" -eq 0 ]

    for name in $(mod_names); do
        [ "$(readlink "$FIXTURE/Mods/$name")" = "$REPO_ROOT/mods/$name" ]
    done

    # A second run must not write anything into the repo. `ln -s` follows an
    # existing symlink-to-a-directory and creates the link *inside* it, which
    # leaves the outer link looking correct — so checking readlink alone is
    # not enough to prove idempotency.
    after="$(find "$REPO_ROOT/mods" | sort)"
    [ "$before" = "$after" ]
}

@test "repoints a stale symlink" {
    local name
    name="$(mod_names | head -1)"
    ln -s /nonexistent/elsewhere "$FIXTURE/Mods/$name"

    run "$SCRIPT"

    [ "$(readlink "$FIXTURE/Mods/$name")" = "$REPO_ROOT/mods/$name" ]
}

@test "refuses to clobber a real directory" {
    local name
    name="$(mod_names | head -1)"
    mkdir -p "$FIXTURE/Mods/$name"
    printf 'precious' > "$FIXTURE/Mods/$name/hand-installed.txt"

    run "$SCRIPT"

    # The important half: the directory survives untouched. Checking only
    # that the file still exists is not enough — ln happily creates the link
    # *inside* a real directory, leaving the original contents in place.
    [ "$(ls -A "$FIXTURE/Mods/$name")" = "hand-installed.txt" ]
    # And the problem is reported rather than scrolling past.
    [ "$status" -ne 0 ]
    [[ "$output" == *"$name"* ]]
}
