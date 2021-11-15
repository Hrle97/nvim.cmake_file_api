project = "nvim.cmake_file_api"
title = "Neovim CMake File API"
description = "Library using the CMake file API to extract "
  .. "information about generated build systems."
full_description = "CMake provides a file-based API that clients may use to "
  .. "get semantic information about the buildsystems CMake generates. Clients "
  .. "may use the API by writing query files to a specific location in a build "
  .. "tree to request zero or more Object Kinds. When CMake generates the "
  .. "buildsystem in that build tree it will read the query files and write "
  .. "reply files for the client to read. "

not_luadoc = true

template = true
examples = "example"

custom_tags = {
  {
    "link",
    title = "Links",
    format = function(text)
      local name = text:gsub("^%s*(.-)%s*http.*$", "%1", 1)
      local link = text:gsub("^.*%s*(http.-)%s*$", "%1", 1)
      local fmt = "%s: <%s>"

      return fmt:format(name, link)
    end,
  },
  { "homepage", title = "Homepage" },
}

alias("tfield", { "field", modifiers = { type = "$1" } })
