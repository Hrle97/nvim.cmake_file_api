--- CMake File API client implementation for Neovim.
--
-- CMake provides a file-based API that clients may use to get semantic
-- information about the buildsystems CMake generates. Clients may use the API
-- by writing query files to a specific location in a build tree to request zero
-- or more Object Kinds. When CMake generates the buildsystem in that build tree
-- it will read the query files and write reply files for the client to read.
--
-- @link CMake File API documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html
--
-- @module nvim.cmake_file_api
--
-- @author Hrle97 <https://github.com/Hrle97>
-- @copyright © 2021 Hrle97 <32d9c8c6-8118-45e7-857e-8b45522f395d@anonaddy.me>
-- @license MIT License
-- @release 0.0.1
-- @homepage https://github.com/Hrle97/nvim.cmake_file_api
--
-- @todo break up docs into smaller files
local cmake_file_api = {}

local all_in_one = require "nvim.cmake_file_api.all_in_one"
local query = require "nvim.cmake_file_api.query"
local reply = require "nvim.cmake_file_api.reply"
local object = require "nvim.cmake_file_api.object"

-------------------------------------------------------------------------------

--- All in one
--
-- Methods that write a CMake File API query, run a method that generates
-- a buildsystem and read the reply of the CMake File API - easiest to use for
-- beginners.
--
-- @section all_in_one

--- Write a query for everything, configure CMake, and read the reply index of
--  the CMake File API.
--
-- This is the best way to start using the CMake File API if you want to get
-- started quickly because it enables you to extract all information the CMake
-- File API can give you.
--
-- If you already know how the CMake File API works then this writes
-- "codemodel" , "cache", "cmakeFiles", and "tooolchains" stateless client
-- queries and reads the reply index after the configure step is done. The
-- versions of these queries are 2, 2, 1, and 1 respectively.
--
-- See the CMake File API documentation for more info.
--
-- @link CMake File API documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html
--
-- @usage
-- local reply_index = require("nvim.cmake_file_api")
--   .write_configure_read_all(
--     build, -- your build location here
--     function()
--       vim.fn.system {
--         "cmake",
--         "-S",
--         source, -- your source location here
--         "-B",
--         build -- your build location here
--       }
--     end)
--
-- if not reply_index then
--   -- handle errors here
-- end
--
-- @function write_configure_read_all
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam function configure
-- The method to call after writing the query to generate the buildsystem.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply index and on failure, returns a @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_all_queries
-- @see read_reply_index
function cmake_file_api.write_configure_read_all(build, configure, callback)
  return all_in_one.write_configure_read_all(build, configure, callback)
end

--- Write a query, configure CMake, and read the reply of specified kind and
--  version.
--
-- More technically, this writes a client stateless query and reads the reply of
-- the specified kind and version.
--
-- See the object kind documentation for more info.
--
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @link CMake File API documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html
--
-- @usage
-- local codemodel = require("nvim.cmake_file_api")
--   .write_configure_read(
--     build, -- your build location here
--     "codemodel", -- kind of query here
--     2, -- query version here
--     function()
--       vim.fn.system {
--         "cmake",
--         "-S",
--         source, -- your source location here
--         "-B",
--         build -- your build location here
--       }
--     end)
--
-- if not codemodel then
--   -- handle errors here
-- end
--
-- @function write_configure_read
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam string kind
-- The object kind of query and reply. Valid values are: "codemodel", "cache",
-- "cmakeFiles", and "tkolchains". See the object kind documentation for more
-- info.
--
-- @tparam number|string|nil version
-- The major object version of the query and reply. Valid values depend on the
-- query kind. If nil, the latest version for the object kind will be used.
-- Use the @{latest} field for more readability.
-- See the CMake File API documentation for more info.
--
-- @tparam function configure
-- The method to call after writing the query to generate the buildsystem.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_query
-- @see read_reply
-- @see latest
function cmake_file_api.write_configure_read(
  build,
  kind,
  version,
  configure,
  callback
)
  return all_in_one.write_configure_read(
    build,
    kind,
    version,
    configure,
    callback
  )
end

--- Write a query, configure CMake, and read the reply of the "codemodel" kind.
--
-- More technically, this writes a client stateless query and reads the reply of
-- the "codemodel" kind.
--
-- See the "codemodel" object kind documentation for more info.
--
-- @link "codemodel" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-codemodel
--
-- @usage
-- local codemodel = require("nvim.cmake_file_api")
--   .write_configure_read_codemodel(
--     build, -- your build location here
--     2, -- query version here
--     function()
--       vim.fn.system {
--         "cmake",
--         "-S",
--         source, -- your source location here
--         "-B",
--         build -- your build location here
--       }
--     end)
--
-- if not codemodel then
--   -- handle errors here
-- end
--
-- @function write_configure_read_codemodel
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam number|string|nil version
-- The major object version of the query and reply. Valid values are 1 and 2.
-- If nil, 2 is used.
-- Use the @{latest} field for more readability.
--
-- @tparam function configure
-- The method to call after writing the query to generate the buildsystem.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_codemodel_query
-- @see read_codemodel_reply
-- @see latest
function cmake_file_api.write_configure_read_codemodel(
  build,
  version,
  configure,
  callback
)
  return all_in_one.write_configure_read_codemodel(
    build,
    version,
    configure,
    callback
  )
end

--- Write a query, configure CMake, and read the reply of the "cache" kind.
--
-- More technically, this writes a client stateless query and reads the reply of
-- the "cache" kind.
--
-- See the "cache" object kind documentation for more info.
--
-- @link "cache" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-cache
--
-- @usage
-- local cache = require("nvim.cmake_file_api")
--   .write_configure_read_cache(
--     build, -- your build location here
--     2, -- query version here
--     function()
--       vim.fn.system {
--         "cmake",
--         "-S",
--         source, -- your source location here
--         "-B",
--         build -- your build location here
--       }
--     end)
--
-- if not cache then
--   -- handle errors here
-- end
--
-- @function write_configure_read_cache
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam number|string|nil version
-- The major object version of the query and reply. Valid values are 1 and 2.
-- If nil, 2 is used.
-- Use the @{latest} field for more readability.
--
-- @tparam function configure
-- The method to call after writing the query to generate the buildsystem.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_cache_query
-- @see read_cache_reply
-- @see latest
function cmake_file_api.write_configure_read_cache(
  build,
  version,
  configure,
  callback
)
  return all_in_one.write_configure_read_cache(
    build,
    version,
    configure,
    callback
  )
end

--- Write a query, configure CMake, and read the reply of the "cmakeFiles" kind.
--
-- More technically, this writes a client stateless query and reads the reply of
-- the "cmakeFiles" kind.
--
-- See the "cmakeFiles" object kind documentation for more info.
--
-- @link "cmakeFiles" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-cmakeFiles
--
-- @usage
-- local cmake_files = require("nvim.cmake_file_api")
--   .write_configure_read_cmake_files(
--     build, -- your build location here
--     1, -- query version here
--     function()
--       vim.fn.system {
--         "cmake",
--         "-S",
--         source, -- your source location here
--         "-B",
--         build -- your build location here
--       }
--     end)
--
-- if not cmake_files then
--   -- handle errors here
-- end
--
-- @function write_configure_read_cmake_files
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam number|string|nil version
-- The major object version of the query and reply. Valid values are 1 and 2.
-- If nil, 2 is used.
-- Use the @{latest} field for more readability.
--
-- @tparam function configure
-- The method to call after writing the query to generate the buildsystem.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_cmake_files_query
-- @see read_cmake_files_reply
-- @see latest
function cmake_file_api.write_configure_read_cmake_files(
  build,
  version,
  configure,
  callback
)
  return all_in_one.write_configure_read_cmake_files(
    build,
    version,
    configure,
    callback
  )
end

--- Write a query, configure CMake, and read the reply of the "toolchains" kind.
--
-- More technically, this writes a client stateless query and reads the reply of
-- the "toolchains" kind.
--
-- See the "toolchains" object kind documentation for more info.
--
-- @link "toolchains" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-toolchains
--
-- @usage
-- local toolchains = require("nvim.cmake_file_api")
--   .write_configure_read_toolchains(
--     build, -- your build location here
--     1, -- query version here
--     function()
--       vim.fn.system {
--         "cmake",
--         "-S",
--         source, -- your source location here
--         "-B",
--         build -- your build location here
--       }
--     end)
--
-- if not toolchains then
--   -- handle errors here
-- end
--
-- @function write_configure_read_toolchains
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam number|string|nil version
-- The major object version of the query and reply. Valid values are 1 and 2.
-- If nil, 2 is used.
-- Use the @{latest} field for more readability.
--
-- @tparam function configure
-- The method to call after writing the query to generate the buildsystem.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_toolchains_query
-- @see read_toolchains_reply
-- @see latest
function cmake_file_api.write_configure_read_toolchains(
  build,
  version,
  configure,
  callback
)
  return all_in_one.write_configure_read_toolchains(
    build,
    version,
    configure,
    callback
  )
end

--- Queries
--
-- Methods to call before configuring CMake in order to instruct it what data
-- to generate using the API.
--
-- @section queries

--- Write queries for everything to the CMake File API.
--
-- This is the best way to start using the CMake File API if you want to get
-- started quickly and you don't want to use the "all-in-one" methods. Use
-- alongside the @{read_reply_index} method.
--
-- If you already know how the CMake File API works then this writes
-- "codemodel" , "cache", "cmakeFiles", and "tooolchains" stateless client
-- queries. The versions of these queries are 2, 2, 1, and 1 respectively.
--
-- See the CMake File API documentation for more info.
--
-- @link CMake File API documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_all_queries(
--     build -- your build location here
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_all_queries
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
function cmake_file_api.write_all_queries(build, callback)
  return query.write_all_queries(build, callback)
end

--- Write a query for the CMake File API.
--
-- Write a query of the specified kind and version to the CMake File API. Use
-- this alongside the @{read_reply} and read_<object_kind>_reply methods.
-- More technically, this writes a client stateless query of the specified kind
-- and version.
--
-- See the object kind documentation for more info.
--
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @link CMake File API documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_query(
--     build -- your build location here
--     "codemodel", -- your query kind here
--     2, -- your query version here
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_query
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam string kind
-- The kind of query to send. Valid values are: "codemodel", "cache",
-- "cmakeFiles", and "tkolchains". See the object kind documentation for more
-- info.
--
-- @tparam number|string|nil version
-- The major version of the query kind to send. Valid values depend on the query
-- kind. If nil, the latest version for the query kind will be used.
-- Use the @{latest} field for more readability.
-- See the CMake File API documentation for more info.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
-- @see read_reply
-- @see read_codemodel_reply
-- @see read_cache_reply
-- @see read_cmake_files_reply
-- @see read_toolchains_reply
-- @see latest
function cmake_file_api.write_query(build, kind, version, callback)
  return query.write_query(build, kind, version, callback)
end

--- Write a "codemodel" query for the CMake File API.
--
-- The "codemodel" query can be used to extract information about directories,
-- configurations and targets of the generated build system. Use this alongside
-- the @{read_codemodel_reply} method.
-- More technically, it writes a stateless client "codemodel" query of version
-- 2.
--
-- See the "codemodel" object kind documentation for more info.
--
-- @link "codemodel" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-codemodel
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_codemodel_query(
--     build -- your build location here
--     2, -- your query version here
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_codemodel_query
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam number|string|nil version
-- The major version of the "codemodel" query to send. Valid values are: 1 and
-- 2. If nil, 2 is used.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
-- @see read_reply
-- @see read_codemodel_reply
-- @see latest
function cmake_file_api.write_codemodel_query(build, version, callback)
  return query.write_codemodel_query(build, version, callback)
end

--- Write a "cache" query for the CMake File API.
--
-- The "cache" query can be used to extract information about the CMake
-- cache. Use this alongside the @{read_cache_reply} method.
-- More technically, it writes a stateless client "cache" query of version
-- 2.
--
-- See the "cache" object kind documentation for more info.
--
-- @link "cache" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-cache
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_cache_query(
--     build -- your build location here
--     2, -- your query version here
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_cache_query
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam number|string|nil version
-- The major version of the "cache" query to send. Valid values are: 1 and
-- 2. If nil, 2 is used.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
-- @see read_reply
-- @see read_codemodel_reply
-- @see latest
function cmake_file_api.write_cache_query(build, version, callback)
  return query.write_cache_query(build, version, callback)
end

--- Write a "cmakeFiles" query for the CMake File API.
--
-- The "cmakeFiles" query can be used to extract information about the
-- generated CMake build system files. Use this alongside the
-- @{read_cmake_files_reply} method.
-- More technically, it writes a stateless client "cmakeFiles" query of version
-- 1.
--
-- See the "cmakeFiles" object kind documentation for more info.
--
-- @link "cmakeFiles" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-cmakeFiles
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_cmake_files_query(
--     build -- your build location here
--     1, -- your query version here
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_cmake_files_query
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam number|string|nil version
-- The major version of the "cmakeFiles" query to send. 1 is the only valid
-- value. If nil, 1 is used.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
-- @see read_reply
-- @see read_cmake_files_reply
-- @see latest
function cmake_file_api.write_cmake_files_query(build, version, callback)
  return query.write_cmake_files_query(build, version, callback)
end

--- Write a "toolchains" query for the CMake File API.
--
-- The "toolchains" query can be used to extract information about directories,
-- configurations and targets of the generated build system. Use this alongside
-- the @{read_toolchains_reply} method.
-- More technically, it writes a stateless client "toolchains" query of version
-- 2.
--
-- See the "toolchains" object kind documentation for more info.
--
-- @link "toolchains" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-toolchains
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_toolchains_query(
--     build -- your build location here
--     1, -- your query version here
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_toolchains_query
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam number|string|nil version
-- The major version of the "toolchains" query to send. 1 is the only valid
-- value. If nil, 1 is used.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
-- @see read_reply
-- @see read_toolchains_reply
-- @see latest
function cmake_file_api.write_toolchains_query(build, version, callback)
  return query.write_toolchains_query(build, version, callback)
end

--- Write a shared stateless query for the CMake File API.
--
-- The query will be shared with other clients such as IDE's and editors and is
-- therefore not recommended for use, but is implemented for the sake of
-- completion of the API.
--
-- See the shared stateless query documentation for more info.
--
-- @link Shared stateless query documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-shared-stateless-query-files
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_shared_stateless_query(
--     build, -- your build location here
--     "codemodel", -- your query kind here
--     2 -- your query version here
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_shared_stateless_query
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam string kind
-- The kind of query to send. Valid values are: "codemodel", "cache",
-- "cmakeFiles", and "tkolchains". See the object kind documentation for more
-- info.
--
-- @tparam number|string|nil version
-- The major version of the query kind to send. Valid values depend on the query
-- kind. If nil, the latest version for the query kind will be used.
-- See the CMake File API documentation for more info.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
-- @see latest
function cmake_file_api.write_shared_stateless_query(
  build,
  kind,
  version,
  callback
)
  return query.write_shared_stateless_query(build, kind, version, callback)
end

--- Write a client stateless query for the CMake File API.
--
-- The query won't be shared with other clients such as IDE's and
-- editors. Methods with the name write_<object_kind>_query use this method to
-- write their queries.
--
-- See the client stateless query documentation for more info.
--
-- @link Client stateless query documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-client-stateless-query-files
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_client_stateless_query(
--     build, -- your build location here
--     "codemodel", -- your query kind here
--     2 -- your query version here
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_client_stateless_query
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam string kind
-- The kind of query to send. Valid values are: "codemodel", "cache",
-- "cmakeFiles", and "toolchains". See the object kind documentation for more
-- info.
--
-- @tparam number|string|nil version
-- The major version of the query kind to send. Valid values depend on the query
-- kind. If nil, the latest version for the query kind will be used.
-- Use the @{latest} field for more readability.
-- See the CMake File API documentation for more info.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
-- @see write_query
-- @see write_codemodel_query
-- @see write_cache_query
-- @see write_cmake_files_query
-- @see write_toolchains_query
-- @see latest
function cmake_file_api.write_client_stateless_query(
  build,
  kind,
  version,
  callback
)
  return query.write_client_stateless_query(build, kind, version, callback)
end

--- Write a client stateful query for the CMake File API.
--
-- The query won't be shared with other clients such as IDE's and editors. Use
-- only if you know exactly what you are doing.
--
-- See the shared stateless query documentation for more info.
--
-- @link Client stateful query documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-client-stateful-query-files
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @usage
-- local did_write = require("nvim.cmake_file_api")
--   .write_client_stateful_query(
--     build, -- your build location here
--     {
--       requests = { -- your requests here
--         { kind = "codemodel", version = 2 },
--       },
--       client = { } -- other info available in the reply here
--     }
--   )
--
-- if not did_write then
--   -- handle errors here
-- end
--
-- @function write_client_stateful_query
--
-- @tparam string build
-- The build directory of the to be generated buildsystem.
--
-- @tparam table query
-- The query to send to the CMake File API. Reqd the client statefull query
-- documentation for more info.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn boolean|@{fail}
-- On success, returns true and on failure, returns a @{fail}.
--
-- @see fail
function cmake_file_api.write_client_stateful_query(build, _query, callback)
  return query.write_client_stateful_query(build, _query, callback)
end

-------------------------------------------------------------------------------

--- Reply
--
-- Functions and classes to use after configuring CMake in order to read the
-- reply of the API.
--
-- @section reply

--- Read the reply index from the CMake File API.
--
-- After configuration, CMake will generate the reply index with links to the
-- desired replies if a query was written.
--
-- This is the best way to start using the CMake File API if you want to get
-- started quickly and you don't want to use the "all-in-one" methods. Use this
-- alongside the @{write_all_queries} method.
--
-- See the reply index file documentation for more info.
--
-- @link Reply index file documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-reply-index-file
--
-- @usage
-- local reply_index = require("nvim.cmake_file_api")
--   .read_reply_index(
--     build -- your build location here
--   )
--
-- if not reply_index then
--   -- handle errors here
-- end
--
-- @function read_reply_index
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply index and on failure, returns a @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_all_queries
function cmake_file_api.read_reply_index(build, callback)
  return reply.read_reply_index(build, callback)
end

--- Read a reply from the CMake File API.
--
-- Reads the reply index and reads the desired reply kind from the file
-- specifiend in the index. Use this alongside the write_<object_kind>_query
-- and the @{write_query} methods.
--
-- See the object kind documentation for more info.
--
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @usage
-- local reply = require("nvim.cmake_file_api")
--   .read_reply(
--     build, -- your build location here
--     "codemodel", -- your query kind here
--     2 -- your query version here
--   )
--
-- if not reply then
--   -- handle errors here
-- end
--
-- @function read_reply
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam string kind
-- The kind of reply to read. Valid values are: "codemodel", "cache",
-- "cmakeFiles", and "toolchains". See the object kind documentation for more
-- info.
--
-- @tparam number|string|nil version
-- The major version of the reply kind to read. Valid values depend on the query
-- kind. If nil, the latest version for the query kind will be used.
-- See the CMake File API documentation for more info.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_query
-- @see write_codemodel_query
-- @see write_cache_query
-- @see write_cmake_files_query
-- @see write_toolchains_query
-- @see latest
function cmake_file_api.read_reply(build, kind, version, callback)
  return reply.read_reply(build, kind, version, callback)
end

--- Read a "codemodel" reply from the CMake File API.
--
-- Reads the reply index and reads the "codemodel" reply from the file
-- specifiend in the index. Use this alongside the and the
-- @{write_codemodel_query} method.
--
-- See the "codemodel" object kind documentation for more info.
--
-- @link "codemodel" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-codemodel
--
-- @usage
-- local codemodel = require("nvim.cmake_file_api")
--   .read_codemodel_reply(
--     build, -- your build location here
--     2 -- your query version here
--   )
--
-- if not codemodel then
--   -- handle errors here
-- end
--
-- @function read_codemodel_reply
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam number|string|nil version
-- The major version of the "codemodel" reply to read. Valid values are 1 and
-- 2. If nil, the version is 2.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_codemodel_query
-- @see latest
function cmake_file_api.read_codemodel_reply(build, version, callback)
  return reply.read_codemodel_reply(build, version, callback)
end

--- Read a "cache" reply from the CMake File API.
--
-- Reads the reply index and reads the "cache" reply from the file
-- specifiend in the index. Use this alongside the and the
-- @{write_cache_query} method.
--
-- See the "cache" object kind documentation for more info.
--
-- @link "cache" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-cache
--
-- @usage
-- local cache = require("nvim.cmake_file_api")
--   .read_cache_reply(
--     build, -- your build location here
--     2 -- your query version here
--   )
--
-- if not cache then
--   -- handle errors here
-- end
--
-- @function read_cache_reply
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam number|string|nil version
-- The major version of the "cache" reply to read. Valid values are 1 and
-- 2. If nil, the version is 2.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_cache_query
-- @see latest
function cmake_file_api.read_cache_reply(build, version, callback)
  return reply.read_cache_reply(build, version, callback)
end

--- Read a "cmakeFile" reply from the CMake File API.
--
-- Reads the reply index and reads the "cmakeFile" reply from the file
-- specifiend in the index. Use this alongside the and the
-- @{write_cmake_files_query} method.
--
-- See the "cmakeFile" object kind documentation for more info.
--
-- @link "cmakeFile" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-cmakeFile
--
-- @usage
-- local cmake_files = require("nvim.cmake_file_api")
--   .read_cmake_files_reply(
--     build, -- your build location here
--     1 -- your query version here
--   )
--
-- if not cmake_files then
--   -- handle errors here
-- end
--
-- @function read_cmake_files_reply
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam number|string|nil version
-- The major version of the "cmakeFile" reply to read. 1 is the only valid
-- value. If nil, the version is 1.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_cmake_files_query
-- @see latest
function cmake_file_api.read_cmake_files_reply(build, version, callback)
  return reply.read_cmake_files_reply(build, version, callback)
end

--- Read a "toolchains" reply from the CMake File API.
--
-- Reads the reply index and reads the "toolchains" reply from the file
-- specifiend in the index. Use this alongside the and the
-- @{write_toolchains_query} method.
--
-- See the "toolchains" object kind documentation for more info.
--
-- @link "toolchains" object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kind-toolchains
--
-- @usage
-- local toolchains = require("nvim.cmake_file_api")
--   .read_toolchains_reply(
--     build, -- your build location here
--     1 -- your query version here
--   )
--
-- if not toolchains then
--   -- handle errors here
-- end
--
-- @function read_toolchains_reply
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam number|string|nil version
-- The major version of the "toolchains" reply to read. 1 is the only valid
-- value. If nil, the version is 1.
-- Use the @{latest} field for more readability.
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the reply as a @{object} and on failure, returns a
-- @{fail}.
--
-- @see fail
-- @see object
-- @see lazy
-- @see write_toolchains_query
-- @see latest
function cmake_file_api.read_toolchains_reply(build, version, callback)
  return reply.read_toolchains_reply(build, version, callback)
end

--- Reply object class.
--
-- Returned by the read_reply methods. All the fields of this type are
-- the same as in the reply index file documentation except for special fields
-- that have the key "jsonFile". These fields are not immediately loaded and
-- are instead initialized as a @{lazy}. Lazy objects have a path field and a
-- load method which can run synchronously and asynchronously to retrieve the
-- desired field as a @{object}.
--
-- @type object
--
-- @tfield string path
-- Path to the JSON file from which this will be read with the @{lazy:load}
-- method.
--
-- @field data Data that was read from the JSON file that this was loaded from.
--
-- @link Reply index file documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-reply-index-file
--
-- @see lazy
-- @see read_reply_index
-- @see read_reply
-- @see read_codemodel_reply
-- @see read_cache_reply
-- @see read_cmake_files_reply
-- @see read_toolchains_reply
cmake_file_api.object = {}

--- Check if a value is a @{object}.
--
-- @function object.is_object
--
-- @param   value   Value to check against.
-- @treturn boolean Whether the value is an @{object}.
function cmake_file_api.object.is_object(value)
  return object.object.is_object(value)
end

--- Create a new @{object}.
--
-- Values of fields with the key "jsonFile" are going to be converted to
-- @{lazy} values.
--
-- @function object.new
--
-- @tparam  string path Path to the JSON file from which this was read.
--
-- @tparam string kind
-- The kind of query to send. Valid values are: "codemodel", "cache",
-- "cmakeFiles", and "toolchains". See the object kind documentation for more
-- info.
--
-- @tparam  table  data
-- Data representing some values of the reply.
--
-- @treturn @{object}   Constructed @{object}.
--
-- @see lazy
function cmake_file_api.object.new(path, data)
  return object.object.new(path, data)
end

--- Lazy object field class.
--
-- Values of fields with the key "jsonFiles" of API replies are converted to
-- @{lazy} values that can be loaded synchronously or asynchronously with the
-- @{lazy:load} method into an @{object}.
--
-- @type lazy
--
-- @tfield string path
-- Path to the JSON file from which this will be read with the @{lazy:load}
-- method.
--
-- @link CMake File API documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html
--
-- @see object
cmake_file_api.lazy = {}

--- Check if a value is a @{lazy}.
--
-- @function lazy.is_lazy
--
-- @param   value   Value to check against.
-- @treturn boolean Whether the value is a @{lazy}.
function cmake_file_api.lazy.is_lazy(value)
  return object.lazy.is_lazy(value)
end

--- Create a new @{lazy}
--
-- The @{lazy} can be loaded later into an @{object} with the @{lazy:load}
-- method.
--
-- @function lazy.new
--
-- @tparam  string  path Path to the JSON file from which this will be read.
-- @treturn @{lazy}      Constructed @{lazy}.
function cmake_file_api.lazy.new(path)
  return object.lazy.new(path)
end

--- Load a @{lazy}.
--
-- Load a @{lazy} into an @{object} synchronously or asynchronously.
--
-- @usage
-- local object = lazy -- your lazy object here
--   :load()
--
-- if not object then
--   -- handle errors here
-- end
--
-- @function lazy:load
--
-- @tparam[opt] function|thread|nil callback
-- If not nil, the method will run asynchronously and call the callback or
-- resume the thread upon completion with the result as its parameters.
-- Otherwise, it will run synchronously.
-- Note: Use vim.schedule or vim.schedule_wrap to run Vim methods from this
-- callback.
--
-- @treturn @{object}|@{fail}
-- On success, returns the lazy loaded as a @{object} and on failure, returns
-- a @{fail}.
--
-- @see fail
-- @see object
function cmake_file_api.lazy:load(callback)
  return object.lazy.load(self, callback)
end

--- Fail result type.
--
-- This is not an actual type exported in the CMake File API, but a type that
-- describes how methods in the API handle errors.
--
-- It is returned by all methods when an error occured that is not due to the
-- developer using the API, such as not having privileges to write files or
-- make directories. It is very similar to the fail type defined in the luvit
-- library documentation provided in vim.loop, so check the luvit error
-- documentation for more information.
--
-- In place of the type of result that a method would produce upon success nil
-- is returned instead and error details are returned in the rest of the reply.
--
-- For errors that were caused by developers using the API, such as providing
-- a non existing query kind or version or trying to read a reply when CMake
-- was not configured, an assertion is thrown.
--
-- @type fail
--
-- @link luvit error documentation
-- https://github.com/luvit/luv/blob/master/docs.md#error-handling
--
-- @todo better

--- Utilities.
--
-- Miscellaneous utilities and methods that make it easier to use the CMake
-- file API.
--
-- @section utilities

--- Latest version of object kinds
--
-- This is just equal to nil, but it makes it makes using latest versions of
-- object kinds more readable instead of just passing nil.
--
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @field latest
cmake_file_api.latest = nil

return cmake_file_api