project = "nvim.cmake_file_api"
description = "Library for dealing with the CMake file API used to extract "
  .. "information about generated build systems."
full_description = "CMake provides a file-based API that clients may use to "
  .. "get semantic information about the buildsystems CMake generates. Clients "
  .. "may use the API by writing query files to a specific location in a build "
  .. "tree to request zero or more Object Kinds. When CMake generates the "
  .. "buildsystem in that build tree it will read the query files and write "
  .. "reply files for the client to read. "

not_luadoc = true

format = "markdown"

custom_tags = { { "link", title = "Links" } }
