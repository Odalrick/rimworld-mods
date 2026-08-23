#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rimworld_dir="${RIMWORLD_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld}"
mods_dir="$rimworld_dir/Mods"

for source in "$repo_root"/mods/*/; do
    source="${source%/}"
    name="$(basename "$source")"
    target="$mods_dir/$name"

    if [[ -L $target && "$(readlink "$target")" == "$source" ]]; then
        echo "ok       $name"
        continue
    fi

    if [[ -L $target ]]; then
        rm "$target"
        ln -s "$source" "$target"
        echo "relinked $name"
        continue
    fi

    # -n keeps ln from following an existing symlink-to-a-directory and
    # creating the link inside it. The branch above already prevents that
    # case; -n makes the mistake loud rather than silent if it recurs.
    ln -sn "$source" "$target"
    echo "linked   $name"
done
