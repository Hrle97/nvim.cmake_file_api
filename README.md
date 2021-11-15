# Neovim CMake File API

Library using the CMake File API to extract information about generated build
systems.

CMake provides a file-based API that clients may use to get semantic
information about the buildsystems CMake generates. Clients may use the API by
writing query files to a specific location in a build tree to request zero or
more Object Kinds. When CMake generates the buildsystem in that build tree it
will read the query files and write reply files for the client to read.

Read the [CMake File API documentation](https://cmake.org/cmake/help/v3.21/manual/cmake-file-api.7.html) for more information.

## Installation

With [Packer](https://github.com/wbthomason/packer.nvim):

`require("packer").use "Hrle97/nvim.cmake_file_api"`

With [Paq](https://github.com/savq/paq-nvim):

`require("paq"){"Hrle97/nvim.cmake_file_api"}`

## Examples

This is the simples way to use the API:

```
local cmake_file_api = require "nvim.cmake_file_api"

local reply_index = cmake_file_api.write_configure_read_all(
  build, -- your build location here
  cmake.configure -- use vim.fn.system or vim.loop.spawn or io.popen ...
)

-- read data from the reply index here!
```

## Documentation

This is an overview of the documentation for the Neovim CMake File API.

### All-in-one Methods

Methods that write a CMake File API query, run a method that generates
a buildsystem and read the reply of the CMake File API - easiest to use for
beginners.

#### Usage

### Query Methods

Methods to call before configuring CMake in order to instruct it what data to
generate using the API.

#### Usage

### Reply Methods

Functions and classes to use after configuring CMake in order to read the
reply of the API.

#### Usage

### Object Class

Returned by the all-in-one and reply methods. All the fields of this type are
the same as in the reply index file documentation except for special fields
that have the key "jsonFile". These fields are not immediately loaded and are
instead initialized as a lazy with the "lazy" key. Lazy objects have a path
field and a load method which can run synchronously and asynchronously to
retrieve the desired field as an object.

#### Usage

### Lazy Class

Values of fields with the key "jsonFiles" of API replies are converted to lazy
values with the "lazy" key that can be loaded synchronously or asynchronously
with the load method into an object.

#### Usage

### Fail Type

This is not an actual class exported in the CMake File API, but a type that
describes how methods in the API handle errors.

It is returned by all methods when an error occurs that is not due to the
developer using the API, such as not having privileges to write files or make
directories. It is very similar to the fail type defined in the luvit library
documentation provided in vim.loop, so check the luvit error documentation for
more information.

In place of the type of result that a method would produce upon success nil is
returned instead and error details are returned in the rest of the reply.

For errors that were caused by developers using the API, such as providing a
non existing query kind or version or trying to read a reply when CMake was
not configured, an assertion is thrown.

### Utilities

Miscellaneous utilities and methods that make it easier to use the API.

## Error handling

#### Example
