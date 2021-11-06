#!/usr/bin/env bash
set -euo pipefail

declare -g root_path test_root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"
test_root_path="$root_path/test"

# declare -g out_file
# out_file="$(mktemp)"
# trap "rm -f $out_file" EXIT

function main() 
{
      # -c "lua vim.g.out_file_path = '$out_file'" \
      # -c "lua io.output(vim.g.out_file_path)" \
  if nvim --headless --noplugin \
      -c "lua vim.g.root_path = '$root_path'" \
      -c "lua vim.g.test_root_path = '$test_root_path'" \
      -c "lua vim.o.runtimepath = 
            vim.o.runtimepath .. ',' .. 
            vim.g.root_path .. ',' .. 
            vim.g.test_root_path" \
      -c "luafile $root_path/test/lua/init.lua" \
      -c ':q' 2>&1; then
    # cat "$out_file"
    echo "PASS"
  else
    # cat "$out_file"
    echo "FAIL"
    return 1
  fi
}

main "$@"
