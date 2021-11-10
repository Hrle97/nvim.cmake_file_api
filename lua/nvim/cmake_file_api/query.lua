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
    return
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
    return
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
    return
  end

  fs.mkdir(query_dir, function()
    fs.write(query_path, _query, function()
      callback()
    end)
  end)
end

function query.write_query(build, kind, version, callback)
  query.write_client_stateless_query(build, kind, version, callback)
end

function query.write_codemodel_query(build, version, callback)
  query.write_query(build, "codemodel", version, callback)
end

function query.write_cache_query(build, version, callback)
  query.write_query(build, "cache", version, callback)
end

function query.write_cmake_files_query(build, version, callback)
  query.write_query(build, "cmakeFiles", version, callback)
end

function query.write_toolchains_query(build, version, callback)
  query.write_query(build, "toolchains", version, callback)
end

function query.write_all_queries(build, callback)
  if not callback then
    query.write_codemodel_query(build)
    query.write_cache_query(build)
    query.write_cmake_files_query(build)
    query.write_toolchains_query(build)
    return
  end

  query.write_codemodel_query(build, nil, function()
    query.write_cache_query(build, nil, function()
      query.write_cmake_files_query(build, nil, function()
        query.write_toolchains_query(build, nil, callback)
      end)
    end)
  end)
end

return query
