#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rimworld_dir="${RIMWORLD_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/Steam/steamapps/common/RimWorld}"
mods_dir="$rimworld_dir/Mods"

for source in "$repo_root"/mods/*/; do
    source="${source%/}"
    name="$(basename "$source")"
    ln -s "$source" "$mods_dir/$name"
    echo "linked   $name"
done
