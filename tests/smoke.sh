#!/bin/sh
set -eu
CONFIG_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export CONFIG_ROOT
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT HUP INT TERM
HOME="$scratch/home"
export HOME
mkdir -p "$HOME/.vim"
TEST_ERRORS="$scratch/errors"
export TEST_ERRORS
for EXPECTED_THEME in monokai default; do
  export EXPECTED_THEME
  if [ "$EXPECTED_THEME" = monokai ]; then
    ln -s "$CONFIG_ROOT/colors" "$HOME/.vim/colors"
  else
    rm "$HOME/.vim/colors"
  fi
  for TRUECOLOR_CASE in truecolor 24bit missing unknown force-on force-off preserve; do
    TERM=xterm-256color
    unset COLORTERM
    TRUECOLOR_OVERRIDE=
    INITIAL_TRUECOLOR=0
    EXPECTED_TRUECOLOR=0
    case "$TRUECOLOR_CASE" in
      truecolor|24bit) COLORTERM=$TRUECOLOR_CASE; EXPECTED_TRUECOLOR=1 ;;
      missing) TERM=dumb ;;
      unknown) COLORTERM=unsupported ;;
      force-on) TRUECOLOR_OVERRIDE=1; EXPECTED_TRUECOLOR=1 ;;
      force-off) COLORTERM=truecolor; TRUECOLOR_OVERRIDE=0; INITIAL_TRUECOLOR=1 ;;
      preserve) INITIAL_TRUECOLOR=1; EXPECTED_TRUECOLOR=1 ;;
    esac
    export TERM COLORTERM TRUECOLOR_CASE TRUECOLOR_OVERRIDE INITIAL_TRUECOLOR EXPECTED_TRUECOLOR
    if ! vim -Nu NONE -i NONE -n -es -S "$CONFIG_ROOT/tests/check.vim" >"$scratch/log" 2>&1; then
      cat "$scratch/log"
      [ ! -f "$TEST_ERRORS" ] || cat "$TEST_ERRORS"
      exit 1
    fi
  done
done
for path in .netrwhist .viminfo example.swp example.swo example.swn \
  .example.swm .example.swa .example.svz .example.saa \
  nested/.example.swm nested/.example.saa example.un~ example~ undo/state; do
  git -C "$CONFIG_ROOT" check-ignore --no-index -q "$path"
done
for path in colors/monokai.vim diagram.svg query.sql movie.swf script.sh .config.json .example.swq; do
  if git -C "$CONFIG_ROOT" check-ignore --no-index -q "$path"; then
    printf 'Unrelated file must not be ignored: %s\n' "$path" >&2
    exit 1
  fi
done
printf '%s\n' 'Vim smoke tests passed (theme present/missing, truecolor matrix, options, filetypes, ignores).'
