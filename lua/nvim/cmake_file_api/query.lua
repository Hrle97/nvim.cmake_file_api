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
  version = assert.ensure_object_version(
    kind,
    version,
    "Shared stateless query requires a valid object kind version."
  )
  callback = assert.ensure_callback_or_nil(
    callback,
    "Shared stateless query requires a valid callback."
  )

  local query_dir = build .. path.query_infix
  local query_path = query_dir .. kind .. "-v" .. version

  if not callback then
    fs.mkdir(query_dir)
    fs.touch(query_path)
  end

  fs.mkdir(query_dir, function()
    fs.touch(query_path, function()
      callback()
    end)
  end)
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
  version = assert.ensure_object_version(
    kind,
    version,
    "Client stateless query requires a valid object kind version."
  )
  callback = assert.ensure_callback_or_nil(
    callback,
    "Client stateless query requires a valid callback."
  )

  local query_dir = build .. path.client_query_infix
  local query_path = query_dir .. kind .. "-v" .. version

  if not callback then
    fs.mkdir(query_dir)
    fs.touch(query_path)
  end

  fs.mkdir(query_dir, function()
    fs.touch(query_path, function()
      callback()
    end)
  end)
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

  local query_dir = build .. path.client_query_infix
  local query_path = query_dir .. path.client_stateful_query_file_name

  if not callback then
    fs.mkdir(query_dir)
    fs.write(query_path, _query)
  end

  fs.mkdir(query_dir, function()
    fs.write(query_path, _query, function()
      callback()
    end)
  end)
end

return query
