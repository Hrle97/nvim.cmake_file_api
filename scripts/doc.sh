#!/usr/bin/env bash
set -euo pipefail

declare -g root_path doc_root_path doc_scripts_root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"
doc_root_path="$root_path/doc"
doc_scripts_root_path="$root_path/scripts/doc"

declare -g doc_file
doc_file="$root_path/lua/nvim/cmake_file_api/init.lua"

declare -g doc_html_scripts_root_path doc_html_config_file doc_html_gen_path
doc_html_scripts_root_path="$doc_scripts_root_path/html"
doc_html_config_file="$doc_html_scripts_root_path/config.lua"

declare -g doc_html_gen_path
doc_html_gen_path="$root_path/.doc/html"

declare -g doc_vimwiki_scripts_root_path doc_vimwiki_config_file
doc_vimwiki_scripts_root_path="$doc_scripts_root_path/vimwiki"
doc_vimwiki_config_file="$doc_vimwiki_scripts_root_path/config.lua"

declare -g doc_vimwiki_gen_path 
doc_vimwiki_gen_path="$root_path/doc"
declare -g doc_vimwiki_gen_name 
doc_vimwiki_gen_name="cmake_file_api"
declare -g doc_vimwiki_gen_ext 
doc_vimwiki_gen_ext="txt"
declare -g doc_vimwiki_unnecessary_css_path
doc_vimwiki_unnecessary_css_path="$doc_vimwiki_gen_path/ldoc.css"

function main() 
{
  ldoc \
    --config "$doc_html_config_file" \
    --dir "$doc_html_gen_path" \
    --style "$doc_html_scripts_root_path" \
    "$doc_file"

  ldoc \
    --config "$doc_vimwiki_config_file" \
    --dir "$doc_vimwiki_gen_path" \
    --output "$doc_vimwiki_gen_name" \
    --ext "$doc_vimwiki_gen_ext" \
    "$doc_file"

  rm "$doc_vimwiki_unnecessary_css_path"
}

main "$@"
