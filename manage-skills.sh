#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
GLOBAL_SKILLS_DIR="$HOME/.claude/skills"

if ! command -v fzf &>/dev/null; then
  echo "Error: fzf is required. Install with: brew install fzf"
  exit 1
fi

mkdir -p "$GLOBAL_SKILLS_DIR"

# Collect all skills (directories containing SKILL.md)
skills=()
while IFS= read -r dir; do
  skills+=("$(basename "$dir")")
done < <(find "$REPO_DIR" -maxdepth 2 -name SKILL.md -exec dirname {} \; | sort)

# Determine which are currently symlinked to this repo
preselected=()
for skill in "${skills[@]}"; do
  target="$GLOBAL_SKILLS_DIR/$skill"
  if [ -L "$target" ] && [[ "$(readlink "$target")" == "$REPO_DIR/$skill" ]]; then
    preselected+=("$skill")
  fi
done

# Build fzf pre-selection bind string
bind_str=""
if [ ${#preselected[@]} -gt 0 ]; then
  bind_str="start:"
  for skill in "${preselected[@]}"; do
    # Find 1-based position of this skill in the sorted list
    pos=1
    for s in "${skills[@]}"; do
      if [[ "$s" == "$skill" ]]; then
        bind_str+="pos($pos)+select+"
        break
      fi
      pos=$((pos + 1))
    done
  done
  bind_str+="first"
fi

fzf_args=(--multi --sync
  --header="Toggle skills for ~/.claude/skills/ (TAB to select, ENTER to confirm, Ctrl-A toggle all)"
  --bind="ctrl-a:toggle-all"
)
[ -n "$bind_str" ] && fzf_args+=(--bind="$bind_str")

selected=$(printf '%s\n' "${skills[@]}" | fzf "${fzf_args[@]}") || { echo "Cancelled."; exit 0; }

# Convert selected to an array
selected_arr=()
while IFS= read -r line; do
  [[ -n "$line" ]] && selected_arr+=("$line")
done <<< "$selected"

# Sync: add new symlinks
for skill in "${selected_arr[@]}"; do
  target="$GLOBAL_SKILLS_DIR/$skill"
  if [ -L "$target" ] && [[ "$(readlink "$target")" == "$REPO_DIR/$skill" ]]; then
    continue # already correct
  elif [ -e "$target" ]; then
    echo "Warning: $target already exists and is not a symlink to this repo. Skipping."
    continue
  fi
  ln -s "$REPO_DIR/$skill" "$target"
  echo "Added: $skill"
done

# Sync: remove deselected symlinks (only those pointing to this repo)
for skill in "${skills[@]}"; do
  target="$GLOBAL_SKILLS_DIR/$skill"
  if [ -L "$target" ] && [[ "$(readlink "$target")" == "$REPO_DIR/$skill" ]]; then
    # Check if it's in the selected list
    found=false
    for s in "${selected_arr[@]}"; do
      if [[ "$s" == "$skill" ]]; then
        found=true
        break
      fi
    done
    if ! $found; then
      rm "$target"
      echo "Removed: $skill"
    fi
  fi
done

echo "Done."
