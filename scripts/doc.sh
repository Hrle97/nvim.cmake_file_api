#!/usr/bin/env bash
set -euo pipefail

declare -g root_path doc_root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"
doc_root_path="$root_path/doc"

declare -g doc_config_file
doc_config_file="$doc_root_path/config.lua"

declare -g doc_file
doc_file="$root_path/lua/nvim/cmake_file_api/init.lua"

declare -g doc_gen_path
doc_gen_path="$root_path/.doc"

function main() 
{
  ldoc --config "$doc_config_file" --dir "$doc_gen_path" "$doc_file"
}

main "$@"
