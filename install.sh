#!/usr/bin/env bash
# Install the skills in this repo for Claude Code (~/.claude/skills) and for the
# agents that read ~/.agents/skills (Codex and others). It links by default, so
# a `git pull` here updates every agent at once.
#
#   ./install.sh                  link every skill
#   ./install.sh NAME...          link only the named skills
#   ./install.sh --copy           copy instead (Windows without symlink rights)
#   ./install.sh --remove         remove what this script installed
#   ./install.sh --force          move an existing skill of the same name aside
#   SKILL_DIRS="a b" ./install.sh install into other folders instead
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mode=link force=0 names=()
for arg in "$@"; do
  case "$arg" in
    --copy) mode=copy ;;
    --remove) mode=remove ;;
    --force) force=1 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    -*) echo "unknown option: $arg" >&2; exit 2 ;;
    *) names+=("$arg") ;;
  esac
done
read -r -a dirs <<< "${SKILL_DIRS:-$HOME/.claude/skills $HOME/.agents/skills}"
if [ ${#names[@]} -eq 0 ]; then
  for d in "$repo"/skills/*/; do names+=("$(basename "$d")"); done
fi

# A skill is ours if it's a link to this repo, or a copy carrying our marker.
ours() {
  { [ -L "$1" ] && [ "$(readlink "$1")" = "$2" ]; } ||
    { [ -f "$1/.installed-from" ] && [ "$(cat "$1/.installed-from")" = "$2" ]; }
}

for name in "${names[@]}"; do
  src="$repo/skills/$name"
  [ -f "$src/SKILL.md" ] || { echo "no skill named $name in $repo/skills" >&2; exit 1; }
  for dir in "${dirs[@]}"; do
    dest="$dir/$name"
    if [ "$mode" = remove ]; then
      if ours "$dest" "$src"; then rm -rf "$dest"; echo "removed $dest"; fi
      continue
    fi
    if [ "$mode" = link ] && [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      echo "ok      $dest"; continue
    fi
    if ours "$dest" "$src"; then
      rm -rf "$dest"
    elif [ -e "$dest" ] || [ -L "$dest" ]; then
      if [ "$force" -eq 0 ]; then
        echo "skipped $dest: something else is there (--force moves it aside)" >&2; continue
      fi
      # Outside the skills folder, so the old copy isn't loaded as a second skill.
      backup="$dir-backup/$name-$(date +%Y%m%d-%H%M%S)"
      mkdir -p "$dir-backup"; mv "$dest" "$backup"; echo "moved   $dest -> $backup"
    fi
    mkdir -p "$dir"
    if [ "$mode" = copy ]; then
      cp -R "$src" "$dest"; printf '%s' "$src" > "$dest/.installed-from"; echo "copied  $dest"
    else
      ln -s "$src" "$dest"; echo "linked  $dest"
    fi
  done
done
