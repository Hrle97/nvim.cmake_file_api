#!/usr/bin/env bash
set -euo pipefail

declare -g root_path test_root_path example_root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"
test_root_path="$root_path/test"
example_root_path="$root_path/example"

function test()
{
  echo -e "TESTING BUILD: '$1', NO PLENARY: '$2'\n"
  if nvim --headless --noplugin \
      -c "lua vim.g.root_path = '$root_path'" \
      -c "lua vim.g.test_root_path = '$test_root_path'" \
      -c "lua vim.g.example_root_path = '$example_root_path'" \
      -c "lua vim.g.cmake_file_api_no_plenary = '$2'" \
      -c "lua vim.g.cmake_source_path = '$test_root_path/cmake/'" \
      -c "lua vim.g.cmake_build_path = '$test_root_path/cmake/$1'" \
      -c "lua vim.o.runtimepath = 
            vim.o.runtimepath .. ',' .. 
            vim.g.root_path .. ',' .. 
            vim.g.test_root_path" \
      -c "luafile $root_path/test/lua/init.lua" \
      -c ':q' 2>&1; then
    echo -e "\nBUILD '$1' PASSED!"
  else
    echo -e "\nBUILD '$1' FAILED!"
    return 1
  fi
}

function main() 
{
  if [ $# -eq 1 ] && [ $1 == "with_plenary" ] 
  then
    test "build_plenary" "false" &
  fi
  test "build_no_plenary" "true" &

  wait $(jobs -p)
}

main "$@"
