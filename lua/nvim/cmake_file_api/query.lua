local query = {}

local path = require "nvim.cmake_file_api.path"
local assert = require "nvim.cmake_file_api.assert"
local fs = require "nvim.cmake_file_api.fs"

function query.write_shared_stateless_query(build, kind, version, callback)
  build = assert.ensure_dir(
    build,
    "Shared stateless query requires a valid build directory."
  )
  kind = assert.ensure_object_kind(
    kind,
    "Shared stateless query requires a valid object kind."
  )
  version = assert.ensure_object_kind_version(
    kind,
    version,
    "Shared stateless query requires a valid object kind version."
  )
  callback = assert.ensure_callback_or_nil(
    callback,
    "Shared stateless query requires a valid callback."
  )

  local query_path = build .. path.query_infix .. kind .. "-v" .. version

  fs.write(query_path, "", callback)
end

function query.write_client_stateless_query(build, kind, version, callback)
  build = assert.ensure_dir(
    build,
    "Client stateless query requires a valid build directory."
  )
  kind = assert.ensure_object_kind(
    kind,
    "Client stateless query requires a valid object kind."
  )
  version = assert.ensure_object_kind_version(
    kind,
    version,
    "Client stateless query requires a valid object kind version."
  )
  callback = assert.ensure_callback_or_nil(
    callback,
    "Client stateless query requires a valid callback."
  )

  local query_path = build .. path.client_query_infix .. kind .. "-v" .. version

  fs.write(query_path, "", callback)
end

function query.write_client_stateful_query(build, _query, callback)
  build = assert.ensure_dir(
    build,
    "Client stateful query requires a valid build directory."
  )
  callback = assert.ensure_callback_or_nil(
    callback,
    "Client stateful query requires a valid callback."
  )

  local query_path = build .. path.client_stateful_query_suffix

  fs.write(query_path, _query, callback)
end

return query
