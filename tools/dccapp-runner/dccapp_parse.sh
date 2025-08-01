#!/usr/bin/env bash
set -euo pipefail
# Parse a Windows .dccapp command line into fields for Linux use
# Usage: dccapp_parse.sh /path/to/file.dccapp
file="$1"
raw=$(tr -d '\r' < "$file")
INI=$(printf '%s' "$raw" | sed -n 's/.*-i"\([^"]\+\)".*/\1/p')
MEM_G=$(printf '%s' "$raw" | sed -n 's/.* -g\([0-9]\+\).*/\1/p' || true)
MEM_MV=$(printf '%s' "$raw" | sed -n 's/.* -mv\([0-9]\+\).*/\1/p' || true)
rest=$(printf '%s' "$raw" | sed 's/^.* -mv[0-9]\+ //; t; s/^.* -g[0-9]\+ //')
read -r ENTRY1 ENTRY2 REMAINDER <<< "$rest"
mapfile -t TOKS < <(printf '%s\n' "$REMAINDER")
if [ "${#TOKS[@]}" -eq 0 ]; then
  mapfile -t ALL < <(printf '%s\n' $rest)
  if [ "${#ALL[@]}" -gt 2 ]; then TOKS=("${ALL[@]:2}"); fi
fi
CN_STR=""; ARGS=()
if [ "${#TOKS[@]}" -gt 0 ]; then
  CN_STR="${TOKS[-1]}"
  if [ "${#TOKS[@]}" -gt 1 ]; then ARGS=("${TOKS[@]:0:${#TOKS[@]}-1}"); fi
fi
printf 'INI=%s\nMEM_G=%s\nMEM_MV=%s\nENTRY1=%s\nENTRY2=%s\nCN_STR=%s\n' "$INI" "${MEM_G:-}" "${MEM_MV:-}" "$ENTRY1" "$ENTRY2" "$CN_STR"
for a in "${ARGS[@]:-}"; do printf 'ARG=%s\n' "$a"; done
