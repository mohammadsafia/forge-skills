#!/usr/bin/env bash

set -uo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
errors=0

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  errors=$((errors + 1))
}

skill_count=0
declare -A seen_names=()

while IFS= read -r skill_file; do
  skill_count=$((skill_count + 1))
  skill_dir=$(dirname "$skill_file")
  folder_name=$(basename "$skill_dir")
  skill_name=$(awk -F': ' '/^name: / { print $2; exit }' "$skill_file")
  description=$(awk -F': ' '/^description: / { sub(/^description: /, ""); print; exit }' "$skill_file")

  [[ $(sed -n '1p' "$skill_file") == '---' ]] || fail "$skill_file does not start with YAML frontmatter"
  [[ -n "$skill_name" ]] || fail "$skill_file is missing a name"
  [[ -n "$description" ]] || fail "$skill_file is missing a description"
  [[ "$skill_name" == "forge:$folder_name" ]] || fail "$skill_file name '$skill_name' does not match folder '$folder_name'"

  if [[ -n ${seen_names[$skill_name]+x} ]]; then
    fail "duplicate skill name '$skill_name'"
  fi
  seen_names[$skill_name]=1

  fence_count=$(awk '/^```/ { count++ } END { print count + 0 }' "$skill_file")
  (( fence_count % 2 == 0 )) || fail "$skill_file has an unmatched fenced code block"

  while IFS= read -r reference; do
    [[ -f "$skill_dir/$reference" ]] || fail "$skill_file references missing file '$reference'"
  done < <(rg -o 'references/[A-Za-z0-9._-]+\.md' "$skill_file" | sort -u)

  while IFS= read -r shared_reference; do
    [[ -f "$skill_dir/$shared_reference" ]] || fail "$skill_file references missing file '$shared_reference'"
  done < <(rg -o '\.\./_shared/[A-Za-z0-9._-]+\.md' "$skill_file" | sort -u)
done < <(find "$repo_root/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | sort)

declared_count=$(sed -nE 's/^([0-9]+) skills covering.*/\1/p' "$repo_root/README.md" | head -1)
[[ "$declared_count" == "$skill_count" ]] || fail "README declares ${declared_count:-no} skills, but found $skill_count"

while IFS= read -r markdown_file; do
  fence_count=$(awk '/^```/ { count++ } END { print count + 0 }' "$markdown_file")
  (( fence_count % 2 == 0 )) || fail "$markdown_file has an unmatched fenced code block"
done < <(find "$repo_root/skills" -type f -name '*.md' | sort)

if (( errors > 0 )); then
  printf '\nValidation failed with %d error(s).\n' "$errors" >&2
  exit 1
fi

printf 'Validated %d skills successfully.\n' "$skill_count"
