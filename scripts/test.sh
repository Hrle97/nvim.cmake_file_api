#!/usr/bin/env bash
set -euo pipefail

declare -g base prog basedir rootdir
base="$(realpath -e "${BASH_SOURCE[0]}")"
prog="$(basename "$base")"
basedir="$(dirname "$base")"
rootdir="$(dirname "$basedir")"

function main() 
{
  if nvim --headless --noplugin \
      -c "luafile $rootdir/test/init.lua" \
      -c ':q' 2>&1; then
    echo "PASS"
  else
    echo "FAIL"
    return 1
  fi
}

main "$@"
