#!/usr/bin/env bash
set -euo pipefail

# root
declare -g root_path doc_root_path doc_scripts_root_path
root_path="$(realpath -e "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)"
doc_root_path="$root_path/doc"
doc_scripts_root_path="$root_path/scripts/doc"

# source
declare -g doc_file
doc_file="$root_path/lua/nvim/cmake_file_api/init.lua"


##############################################################################
# Configs

declare -g doc_html_scripts_root_path doc_html_config_file doc_html_gen_path
doc_html_scripts_root_path="$doc_scripts_root_path/html"
doc_html_config_file="$doc_html_scripts_root_path/config.lua"

declare -g doc_vim_help_scripts_root_path doc_vim_help_config_file
doc_vim_help_scripts_root_path="$doc_scripts_root_path/vim_help"
doc_vim_help_config_file="$doc_vim_help_scripts_root_path/config.lua"


##############################################################################
# Generation

declare -g doc_github_gen_path
doc_github_gen_path="$root_path/.github/pages"

declare -g doc_vim_help_gen_path 
doc_vim_help_gen_path="$root_path/doc"
declare -g doc_vim_help_gen_name 
doc_vim_help_gen_name="cmake_file_api"
declare -g doc_vim_help_gen_ext 
doc_vim_help_gen_ext="txt"
declare -g doc_vim_help_unnecessary_css_path
doc_vim_help_unnecessary_css_path="$doc_vim_help_gen_path/ldoc.css"
declare -g doc_vim_help_unnecessary_examples_path
doc_vim_help_unnecessary_examples_path="$doc_vim_help_gen_path/examples"
declare -g doc_vim_help_unnecessary_topics_path
doc_vim_help_unnecessary_topics_path="$doc_vim_help_gen_path/topics"


function main() 
{
  ldoc \
    --config "$doc_html_config_file" \
    --dir "$doc_github_gen_path" \
    "$doc_file"

  ldoc \
    --config "$doc_vim_help_config_file" \
    --dir "$doc_vim_help_gen_path" \
    --output "$doc_vim_help_gen_name" \
    --ext "$doc_vim_help_gen_ext" \
    "$doc_file"

  rm "$doc_vim_help_unnecessary_css_path"
  rm -r "$doc_vim_help_unnecessary_examples_path"
  # rm -r "$doc_vim_help_unnecessary_topics_path"
}

main "$@"
