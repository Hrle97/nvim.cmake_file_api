local query = {}

local const = require "nvim.cmake_file_api.const"
local assert = require "nvim.cmake_file_api.assert"
local fs = require "nvim.cmake_file_api.fs"
local async = require "nvim.cmake_file_api.async"

local function write_query(
  make_dir,
  make_path,
  build,
  kind,
  version,
  data,
  build_message,
  kind_message,
  version_message,
  data_message,
  callback_message,
  callback
)
  if not callback then
    build = assert.ensure_dir(build, build_message)
    local query_dir = make_dir(build)

    local query_path
    if not data then
      kind = assert.ensure_object_kind(kind, kind_message)
      version = assert.ensure_object_version(kind, version, version_message)

      query_path = make_path(query_dir, kind, version)
    else
      data = assert.ensure_query_data(data, data_message)

      query_path = make_path(query_dir)
    end

    local mkdir_res, mkdir_err, mkdir_type, mkdir_path = fs.mkdir(query_dir)
    if mkdir_err then
      return mkdir_res, mkdir_err, mkdir_type, mkdir_path
    end

    local write_res, write_err, write_type, write_path = fs.write(
      query_path,
      data
    )
    if write_err then
      return write_res, write_err, write_type, write_path
    end

    return write_res
  end

  assert.ensure_dir(build, build_message, function(_build)
    local query_dir = make_dir(_build)

    local query_path
    if not data then
      kind = assert.ensure_object_kind(kind, kind_message)
      version = assert.ensure_object_version(kind, version, version_message)

      query_path = make_path(query_dir, kind, version)
    else
      query_path = make_path(query_dir)
    end

    callback = assert.ensure_callback_or_nil(callback, callback_message)

    fs.mkdir(query_dir, function(mkdir_res, mkdir_err, mkdir_type, mkdir_path)
      if mkdir_err then
        callback(mkdir_res, mkdir_err, mkdir_type, mkdir_path)
        return
      end

      fs.write(query_path, data, callback)
    end)
  end)
end

function query.write_shared_stateless_query(build, kind, version, callback)
  return write_query(
    function(_build)
      return _build .. const.query_infix
    end,
    function(query_dir, _kind, _version)
      return query_dir .. _kind .. "-v" .. _version
    end,
    build,
    kind,
    version,
    nil,
    "Shared stateless query requires a valid build directory.",
    "Shared stateless query requires a valid object kind.",
    "Shared stateless query requires a valid object version.",
    nil,
    "Shared stateless query requires a valid callback.",
    callback
  )
end

function query.write_client_stateless_query(build, kind, version, callback)
  return write_query(
    function(_build)
      return _build .. const.client_query_infix
    end,
    function(query_dir, _kind, _version)
      return query_dir .. _kind .. "-v" .. _version
    end,
    build,
    kind,
    version,
    nil,
    "Client stateless query requires a valid build directory.",
    "Client stateless query requires a valid object kind.",
    "Client stateless query requires a valid object version.",
    nil,
    "Client stateless query requires a valid callback.",
    callback
  )
end

function query.write_client_stateful_query(build, _query, callback)
  return write_query(
    function(_build)
      return _build .. const.client_query_infix
    end,
    function(query_dir, _, _)
      return query_dir .. const.client_stateful_query_file_name
    end,
    build,
    nil,
    nil,
    _query,
    "Client stateful query requires a valid build directory.",
    nil,
    nil,
    "Client stateful query requires valid query data.",
    "Client stateful query requires a valid callback.",
    callback
  )
end

function query.write_query(build, kind, version, callback)
  return write_query(
    function(_build)
      return _build .. const.client_query_infix
    end,
    function(query_dir, _kind, _version)
      return query_dir .. _kind .. "-v" .. _version
    end,
    build,
    kind,
    version,
    nil,
    "Query of kind " .. kind .. " query requires a valid build directory.",
    "Query of kind " .. kind .. " query requires a valid object kind.",
    "Query of kind " .. kind .. " query requires a valid object version.",
    nil,
    "Query of kind " .. kind .. " query requires a valid callback.",
    callback
  )
end

function query.write_codemodel_query(build, version, callback)
  return query.write_query(build, const.codemodel, version, callback)
end

function query.write_cache_query(build, version, callback)
  return query.write_query(build, const.cache, version, callback)
end

function query.write_cmake_files_query(build, version, callback)
  return query.write_query(build, const.cmake_files, version, callback)
end

function query.write_toolchains_query(build, version, callback)
  return query.write_query(build, const.toolchains, version, callback)
end

function query.write_all_queries(build, callback)
  if not callback then
    local cm_res, cm_err, cm_type, cm_path = query.write_codemodel_query(build)
    if cm_err then
      return cm_res, cm_err, cm_type, cm_path
    end

    local c_res, c_err, c_type, c_path = query.write_cache_query(build)
    if c_err then
      return c_res, c_err, c_type, c_path
    end

    local cf_res, cf_err, cf_type, cf_path = query.write_cmake_files_query(
      build
    )
    if cf_err then
      return cf_res, cf_err, cf_type, cf_path
    end

    local t_res, t_err, t_type, t_path = query.write_toolchains_query(build)
    if t_err then
      return t_res, t_err, t_type, t_path
    end

    return true
  end

  query.write_codemodel_query(
    build,
    nil,
    function(cm_res, cm_err, cm_type, cm_path)
      if cm_err then
        callback(cm_res, cm_err, cm_type, cm_path)
        return
      end

      query.write_cache_query(build, nil, function(c_res, c_err, c_type, c_path)
        if c_err then
          callback(c_res, c_err, c_type, c_path)
          return
        end

        query.write_cmake_files_query(
          build,
          nil,
          function(cf_res, cf_err, cf_type, cf_path)
            if cf_err then
              callback(cf_res, cf_err, cf_type, cf_path)
              return
            end

            query.write_toolchains_query(
              build,
              nil,
              function(t_res, t_err, t_type, t_path)
                if t_err then
                  callback(t_res, t_err, t_type, t_path)
                  return
                end

                callback(true)
              end
            )
          end
        )
      end)
    end
  )
end

async.add_scheduled(query)
return query
