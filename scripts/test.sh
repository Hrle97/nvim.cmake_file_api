#!/usr/bin/env bash
set -euo pipefail

declare -g root_path test_root_path example_root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"
test_root_path="$root_path/test"
example_root_path="$root_path/example"

declare -g cmake_root_path test_init_path
cmake_root_path="$test_root_path/cmake"
test_init_path="$test_root_path/lua/init.lua"

function test()
{
  echo -e "\nBUILD: '$1'"

  echo -e "\nRUNNING TESTS\n"
  if nvim --headless --clean \
      -c "lua vim.g.root_path = '$root_path'" \
      -c "lua vim.g.test_root_path = '$test_root_path'" \
      -c "lua vim.g.example_root_path = '$example_root_path'" \
      -c "lua vim.g.cmake_source_path = '$cmake_root_path'" \
      -c "lua vim.g.cmake_build_path = '$1'" \
      -c "lua vim.o.runtimepath = 
            vim.o.runtimepath .. ',' .. 
            vim.g.root_path .. ',' .. 
            vim.g.test_root_path" \
      -c "luafile $test_init_path" 2>&1; then
    echo -e "\nBUILD '$1' PASSED!"
  else
    echo -e "\nBUILD '$1' FAILED!"
    return 1
  fi
}

function main() 
{
  echo -e "CHECKING DEPENDENCIES...\n"
  echo -e "CMAKE:\n"
  cmake --version
  echo -e "\n\nC/C++:\n"
  cc --version
  c++ --version
  echo -e "\nNEOVIM:\n"
  nvim --version
  echo -e "\n"

  if [ $# == 0 ] 
  then
    build_path="$test_root_path/cmake/build"
  else
    build_path="$1"
  fi

  test $build_path &

  wait $(jobs -p)
}

main "$@"
