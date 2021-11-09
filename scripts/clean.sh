#!/usr/bin/env bash
set -euo pipefail

declare -g root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"

declare -g cmake_build_path
cmake_build_path="$root_path/test/cmake/build"

function main() 
{
  rm -rf "$cmake_build_path"
}

main "$@"
