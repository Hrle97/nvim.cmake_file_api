#!/usr/bin/env bash
set -euo pipefail

declare -g root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"

declare -g doc_gen_root_path
doc_gen_root_path="$root_path/.doc"

declare -g cmake_gen_root_path
cmake_gen_root_path="$root_path/.build"

function main() 
{
  rm -rf "$doc_gen_root_path"
  rm -rf "$cmake_gen_root_path"
}

main "$@"
