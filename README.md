# Neovim CMake File API

Library using the CMake File API to extract information about generated build
systems.

CMake provides a file-based API that clients may use to get semantic
information about the buildsystems CMake generates. Clients may use the API by
writing query files to a specific location in a build tree to request zero or
more Object Kinds. When CMake generates the buildsystem in that build tree it
will read the query files and write reply files for the client to read.

Read the [CMake File API documentation](https://cmake.org/cmake/help/v3.21/manual/cmake-file-api.7.html) for more information.

## Dependencies

- Neovim >= 0.6.x  (with cjson)
- CMake  >= 3.14.x (with cmake-file-api)

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

 -- read data from the reply index here
```

## Documentation

This is an overview of the documentation for the Neovim CMake File API.

### All-in-one Methods

Methods that write a CMake File API query, run a method that generates
a buildsystem and read the reply of the CMake File API - easiest to use for
beginners.

#### Usage

```
local cmake_file_api = require "nvim.cmake_file_api"

local codemodel = cmake_file_api.write_configure_read_codemodel(
  build, -- your build location here
  cmake_file_api.latest, -- your query version here
  cmake.configure -- use vim.fn.system or vim.loop.spawn or io.popen ...
)

if not codemodel then
   -- handle errors here
end

 -- read data from the codemodel here
```

### Query Methods

Methods to call before configuring CMake in order to instruct it what data to
generate using the API.

#### Usage

```
local cmake_file_api = require "nvim.cmake_file_api"

local did_write = cmake_file_api.write_codemodel_query(
  build, -- your build location here
  cmake_file_api.latest -- latest for code readability (equal to nil)
)

if not did_write then
   -- handle errors here
end

 -- configure CMake and read the reply here
```

### Reply Methods

Methods to use after configuring CMake in order to read the reply of the API.

#### Usage

```
local cmake_file_api = require "nvim.cmake_file_api"

 -- with a previously wrriten codemodel query and configured CMake
local codemodel = cmake_file_api.read_codemodel_reply(
  build, -- your build location here
  cmake_file_api.latest -- latest for code readability (equal to nil)
)

if not codemodel then
   -- handle errors here
end

 -- do stuff with the codemodel here
```

### Object Class

Returned by the all-in-one and reply methods. All the fields of this type are
the same as in the reply index file documentation except for special fields
that have the key "jsonFile". These fields are not immediately loaded and are
instead initialized as a lazy with the "lazy" key. Lazy objects have a path
field and a load method which can run synchronously and asynchronously to
retrieve the desired field as an object.

#### Usage

```
local cmake_file_api = require "nvim.cmake_file_api"

 -- with a previously wrriten codemodel query and configured CMake
local codemodel = cmake_file_api.read_codemodel_reply(
  build, -- your build location here
  cmake_file_api.latest -- latest for code readability (equal to nil)
)

if not codemodel then
   -- handle errors here
end

 -- do stuff with the codemodel here
```

### Lazy Class

Values of fields with the key "jsonFiles" of API replies are converted to lazy
values with the "lazy" key that can be loaded synchronously or asynchronously
with the load method into an object.

#### Usage

```
 -- object with a lazy field
local my_loaded_object = my_object.lazy:load()

if not my_loaded_object then
   -- handle errors here
end

 -- do stuff with the loaded object here
```

### Fail Type

This is not an actual class exported in the CMake File API, but a type that
describes how methods in the API handle errors.

It is returned by all methods when an error occurs that is not due to the
developer using the API, such as not having privileges to write files or make
directories. It is very similar to the fail type defined in the luvit library
documentation provided in `vim.loop`, so check the
[luvit error documentation](https://github.com/luvit/luv/blob/master/docs.md#error-handling)
for more information.

In place of the result that a method would produce upon success nil is
returned instead and error details are returned in the rest of the reply.

For errors that were caused by developers using the API, such as providing a
non existing query kind or version or trying to read a reply when CMake was
not configured, an assertion is thrown.

### Utilities

Miscellaneous utilities and methods that make it easier to use the API.

## Callbacks

Most methods in the API accept a callback as a last parameter and if a
callback is provided, the method will run asynchronously and call the callback
with the result of the method passed as parameters to the callback.

Callbacks are executed on the luvit event loop and Vim methods are disallowed
there, so if you want to use Vim methods in callbacks you have to wrap
callbacks with `vim.schedule_wrap`.

Read the [luvit documentation](https://github.com/luvit/luv/blob/master/docs.md)
for more information.

## Error handling

Most methods in the CMake File API return errors.

The fail type is returned all methods when an error occurs that is not due to
the developer using the API, such as not having privileges to write files or
make directories. It is very similar to the fail type defined in the luvit library
documentation provided in `vim.loop`, so check the
[luvit error documentation](https://github.com/luvit/luv/blob/master/docs.md#error-handling)
more information.

In place of the result that a method would produce upon success nil is
returned instead and error details are returned in the rest of the reply.

For errors that were caused by developers using the API, such as providing a
non existing query kind or version or trying to read a reply when CMake was
not configured, an assertion is thrown.

#### Example

```
local cmake_file_api = require "nvim.cmake_file_api"

local reply_index, error, error_type, error_path =
  cmake_file_api.write_configure_read_all(
    build, -- your build location here
    cmake.configure -- use vim.fn.system or vim.loop.spawn or io.popen...
  )

 -- handle errors
if error then
   -- handle different error types
  if error_type == "mkdir" then
    print("Failed to make directory at: '" .. error_path .. "'")
  elseif error_type == "opendir" then
    print("Failed to open directory at: '" .. error_path .. "'")
  elseif error_type == "readdir" then
    print("Failed to read directory at: '" .. error_path .. "'")
  elseif error_type == "closedir" then
    print("Failed to close directory at: '" .. error_path .. "'")
  elseif error_type == "open" then
    print("Failed to open file at: '" .. error_path .. "'")
  elseif error_type == "stat" then
    print("Failed to get file info at: '" .. error_path .. "'")
  elseif error_type == "read" then
    print("Failed to read file at: '" .. error_path .. "'")
  elseif error_type == "write" then
    print("Failed to write file at: '" .. error_path .. "'")
  elseif error_type == "close" then
    print("Failed to close file at: '" .. error_path .. "'")
  end

   -- handle luvit error
  print("luvit error: '" .. error .. "'")
end

 -- do stuff with the reply_index here
```
