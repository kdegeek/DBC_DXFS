#!/usr/bin/env bash
set -euo pipefail
# Map PLBWIN .ini [environment] to Linux env vars consumed by DB/C DX
# Usage: ini_to_env.sh /path/to/plbwin.ini /mount/root
INI="$1"; MNT_ROOT="${2:-/mnt/wws}"
section=""
while IFS= read -r line; do
  line="${line%%\r}"
  [ -z "$line" ] && continue
  case "$line" in
    \[*\]) section=${line#[}; section=${section%]} ;;
    \#*|\;*) ;;
    *)
      if [ "$section" = "environment" ] || [ "$section" = "Environment" ]; then
        key=$(printf '%s' "$line" | awk -F'=' '{print $1}' | tr -d ' ')
        val=$(printf '%s' "$line" | awk -F'=' '{ $1=""; sub(/^ *= */,"",$0); print $0 }')
        case "$key" in
          PLB_SYSTEM)
            echo "export PLB_SYSTEM=$MNT_ROOT/pc" ;;
          PLB_PATH)
            out=""; IFS=';' read -r -a parts <<< "$val"
            for p in "${parts[@]}"; do
              [ -z "$p" ] && continue
              p_nbs=$(printf '%s' "$p" | tr -d '\\')
              case "$p_nbs" in
                *wwsxcode*) mapped="$MNT_ROOT/code" ;;
                *wwsxpc*) mapped="$MNT_ROOT/pc" ;;
                *filex*) mapped="$MNT_ROOT/filex" ;;
                *) mapped="$MNT_ROOT/extra" ;;
              esac
              if [ -z "$out" ]; then out="$mapped"; else out="$out:$mapped"; fi
            done
            echo "export PLB_PATH=$out" ;;
          PLB_TERM)
            echo "export PLB_TERM=$(printf '%s' "$val" | tr 'A-Z' 'a-z')" ;;
          PLB_FNC)
            echo "export PLB_FNC=$(printf '%s' "$val" | tr 'A-Z' 'a-z')" ;;
        esac
      fi
    ;;
  esac
done < "$INI"
