#!/usr/bin/env bash
# Checks the repo before a commit (the pre-commit hook runs it):
# - each SKILL.md follows the Agent Skills spec: the name matches its folder, is
#   lowercase with single hyphens and at most 64 characters; the description is
#   on one line and at most 1024 characters;
# - each skill is listed in .claude-plugin/marketplace.json;
# - nothing personal: home folder paths, email addresses, or any word listed in
#   the untracked file .private-words (one per line, # for comments).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
fail=0
err() { printf 'check: %b\n' "$*" >&2; fail=1; }

for md in skills/*/SKILL.md; do
  dir=$(basename "$(dirname "$md")")
  [ "$(head -1 "$md")" = "---" ] || err "$md: no frontmatter"
  fm=$(awk 'NR == 1 { next } /^---$/ { exit } { print }' "$md")
  name=$(printf '%s\n' "$fm" | sed -n 's/^name: *//p')
  desc=$(printf '%s\n' "$fm" | sed -n 's/^description: *//p')
  [ "$name" = "$dir" ] || err "$md: name '$name' must match the folder '$dir'"
  printf '%s' "$name" | grep -Eqx '[a-z0-9]+(-[a-z0-9]+)*' ||
    err "$md: name must be lowercase letters, digits and single hyphens"
  [ "${#name}" -le 64 ] || err "$md: name is over 64 characters"
  [ -n "$desc" ] || err "$md: description is missing (keep it on one line)"
  [ "${#desc}" -le 1024 ] || err "$md: description is ${#desc} characters, over 1024"
  grep -qF "\"./skills/$dir\"" .claude-plugin/marketplace.json ||
    err "$dir: not listed in .claude-plugin/marketplace.json"
done

files=$(git ls-files --cached --others --exclude-standard | grep -vxF .private-words || true)
scan() { printf '%s\n' "$files" | tr '\n' '\0' | xargs -0 grep -nI "$@" 2>/dev/null || true; }
hits=$(scan -E '(/home/|/Users/|[A-Z]:\\Users\\)[A-Za-z0-9_.-]+|[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[A-Za-z.]{2,}' |
  grep -vE '@(example\.(com|org|invalid)|users\.noreply\.github\.com)' || true)
[ -z "$hits" ] || err "a home folder path or an email address:\n$hits"
if [ -f .private-words ]; then
  words=$(grep -v '^[[:space:]]*#' .private-words | grep -v '^[[:space:]]*$' || true)
  if [ -n "$words" ]; then
    hits=$(scan -iF -e "$(printf '%s' "$words")")
    [ -z "$hits" ] || err "a private word:\n$hits"
  fi
fi

[ "$fail" -eq 0 ] && echo "check: ok"
exit "$fail"
