#!/usr/bin/env bash
set -euo pipefail

declare -g root_path test_root_path example_root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"
test_root_path="$root_path/test"
example_root_path="$root_path/example"

function main() 
{
  if nvim --headless --noplugin \
      -c "lua vim.g.root_path = '$root_path'" \
      -c "lua vim.g.test_root_path = '$test_root_path'" \
      -c "lua vim.g.example_root_path = '$example_root_path'" \
      -c "lua vim.o.runtimepath = 
            vim.o.runtimepath .. ',' .. 
            vim.g.root_path .. ',' .. 
            vim.g.test_root_path" \
      -c "luafile $root_path/test/lua/init.lua" \
      -c ':q' 2>&1; then
    echo -e "PASS"
  else
    echo -e "FAIL"
    return 1
  fi
}

main "$@"
