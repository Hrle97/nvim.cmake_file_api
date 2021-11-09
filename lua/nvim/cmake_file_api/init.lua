--- CMake File API client implementation for Neovim.
--
-- CMake provides a file-based API that clients may use to get semantic
-- information about the buildsystems CMake generates. Clients may use the API
-- by writing query files to a specific location in a build tree to request zero
-- or more Object Kinds. When CMake generates the buildsystem in that build tree
-- it will read the query files and write reply files for the client to read.
--
-- @link CMake File API documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-client-stateful-query-files
--
-- @module nvim.cmake_file_api
--
-- @author Hrle97 <https://github.com/Hrle97>
-- @copyright © 2021 Hrle97 <32d9c8c6-8118-45e7-857e-8b45522f395d@anonaddy.me>
-- @license MIT License
-- @release 0.0.1
-- @homepage https://github.com/Hrle97/nvim.cmake_file_api
local cmake_file_api = {}

local query = require "nvim.cmake_file_api.query"
local reply = require "nvim.cmake_file_api.reply"
local object = require "nvim.cmake_file_api.object"

-------------------------------------------------------------------------------

--- Queries
--
-- Functions to call before configuring CMake in order to instruct it what data
-- to generate using the API.
--
-- @section queries

--- Write a shared stateless query for the CMake file API.
--
-- The query will be shared with other clients such as IDE's and editors. See
-- the shared stateless query documentation for more info.
--
-- @link Shared stateless query documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-shared-stateless-query-files
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @function write_shared_stateless_query
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam string kind
-- The kind of query to send. Valid values are: "codemodel", "cache",
-- "cmakeFiles", and "tkolchains". See the object kind documentation for more
-- info.
--
-- @tparam number|string version
-- The major version of the query kind to send. Valid values depend on the query
-- kind. See the CMake File API documentation for more info.
--
-- @tparam[opt] function|string|nil callback
-- It can be a Lua function, a Vim command string, or nil.
-- If not nil, the method will run asynchronously and call the callback upon
-- completion. Otherwise, it will run synchronously.
function cmake_file_api.write_shared_stateless_query(
  build,
  kind,
  version,
  callback
)
  return query.write_shared_stateless_query(build, kind, version, callback)
end

--- Write a client stateless query for the CMake file API.
--
-- The query won't be shared with other clients such as IDE's and editors. See
-- the client stateless query documentation for more info.
--
-- @link Client stateless query documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-client-stateless-query-files
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @function write_client_stateless_query
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam string kind
-- The kind of query to send. Valid values are: "codemodel", "cache",
-- "cmakeFiles", and "toolchains". See the object kind documentation for more
-- info.
--
-- @tparam number|string version
-- The major version of the query kind to send. Valid values depend on the query
-- kind. See the CMake File API documentation for more info.
--
-- @tparam[opt] function|string|nil callback
-- It can be a Lua function, a Vim command string, or nil.
-- If not nil, the method will run asynchronously and call the callback upon
-- completion. Otherwise, it will run synchronously.
function cmake_file_api.write_client_stateless_query(
  build,
  kind,
  version,
  callback
)
  return query.write_client_stateless_query(build, kind, version, callback)
end

--- Write a query for the CMake file API.
--
-- The query will be shared with other clients such as IDE's and editors. See
-- the shared stateless query documentation for more info.
--
-- @link Client stateful query documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-client-stateful-query-files
-- @link Object kind documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#object-kinds
--
-- @function write_client_stateful_query
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam table query
-- The query to send to the CMake file API. Reqd the client statefull query
-- documentation for more info.
--
-- @tparam[opt] function|string|nil callback
-- It can be a Lua function, a Vim command string, or nil.
-- If not nil, the method will run asynchronously and call the callback upon
-- completion. Otherwise, it will run synchronously.
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

--- Read a reply from the CMake file API (it rhymes!).
--
-- See the reply index file documentation for more info.
--
-- @link Reply index file documentation
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-reply-index-file
--
-- @function read_reply
--
-- @tparam string build
-- The build directory of the generated buildsystem. It has to be an already
-- existing directory on the filesystem.
--
-- @tparam[opt] function|string|nil callback
-- It can be a Lua function, a Vim command string, or nil.
-- If not nil, the method will run asynchronously and call the callback upon
-- completion. Otherwise, it will run synchronously.
--
-- @treturn @{object}
-- Returns an @{object} represention the reply.
-- All the fields of this type are the same as in the reply index file
-- documentation except for special fields that have the key "jsonFile". These
-- fields are not immediately loaded and are instead initialized as a @{lazy}.
-- Lazy objects have a path field and a load method which can run synchronously
-- and asynchronously to retrieve the desired field as an @{object}.
--
-- @see object
-- @see lazy
function cmake_file_api.read_reply(build, callback)
  return reply.read_reply(build, callback)
end

--- Reply object class.
--
-- Returned by the @{read_reply} method. All the fields of this type are the
-- same as in the reply index file documentation except for special fields that
-- have the key "jsonFile". These fields are not immediately loaded and are
-- instead initialized as a @{lazy}. Lazy objects have a path field and a load
-- method which can run synchronously and asynchronously to retrieve the desired
-- field as a @{object}.
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
-- @see read_reply
-- @see lazy
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
-- @tparam  table  data Data representing some values of the reply.
-- @treturn @{object}   Constructed @{object}.
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
-- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-client-stateful-query-files
--
-- @see object
-- @see read_reply
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
-- Load a @{lazy} int an @{object} synchronously or asynchronously.
--
-- @function lazy:load
--
-- @tparam[opt] function|string|nil callback
-- It can be a Lua function, a Vim command string, or nil.
-- If not nil, the method will run asynchronously and call the callback upon
-- completion. Otherwise, it will run synchronously.
--
-- @treturn @{object}
-- Loaded @{lazy} as an @{object}.
function cmake_file_api.lazy:load(callback)
  return object.lazy.load(self, callback)
end

return cmake_file_api