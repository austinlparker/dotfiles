#!/usr/bin/env bash
# Claude Code status line — jj-aware
# Receives JSON on stdin from Claude Code

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
dir="${cwd/#$HOME/\~}"
dir_short=$(echo "$dir" | awk -F/ '{if (NF<=2) print $0; else print "…/"$(NF-1)"/"$NF}')

jj_info=""
if jj root --ignore-working-copy 2>/dev/null | grep -q .; then
  # Get short change ID, bookmarks, and description of the working copy (@)
  jj_output=$(jj log --no-graph --ignore-working-copy -r @ \
    -T 'change_id.short(8) ++ " " ++ if(bookmarks, bookmarks.join(",") ++ " ", "") ++ description.first_line()' \
    2>/dev/null)
  if [ -n "$jj_output" ]; then
    # Truncate description to keep the line short
    short=$(echo "$jj_output" | cut -c1-60)

    indicators=""

    # Conflict indicator — show ⚠ if working copy has unresolved conflicts
    has_conflicts=$(jj log --no-graph --ignore-working-copy -r @ -T 'conflict' 2>/dev/null)
    if [ "$has_conflicts" = "true" ]; then
      indicators+=" ⚠"
    fi

    # Empty change indicator — show ∅ if working copy has no diff
    has_diff=$(jj diff --ignore-working-copy -r @ --summary 2>/dev/null | head -1)
    if [ -z "$has_diff" ]; then
      indicators+=" ∅"
    fi

    # Stack depth — count changes between @ and main (ancestors of @, excluding ancestors of main)
    stack_depth=$(jj log --no-graph --ignore-working-copy -r '::@ ~ ::main' -T 'change_id.short(1)' 2>/dev/null | wc -c | tr -d ' ')
    if [ "$stack_depth" -gt 1 ]; then
      indicators+=" ↑${stack_depth}"
    fi

    jj_info=" on  ${short}${indicators}"
  fi
fi

printf "\033[2m󰀵 ap in %s%s at %s\033[0m" "$dir_short" "$jj_info" "$(date +%H:%M:%S)"
