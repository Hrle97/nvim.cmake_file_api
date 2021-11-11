local all = {}

local query = require "nvim.cmake_file_api.query"
local reply = require "nvim.cmake_file_api.reply"
local const = require "nvim.cmake_file_api.const"

function all.write_configure_read_all(build, configure, callback)
  if not callback then
    local w_res, w_err, w_type, w_path = query.write_all_queries(build)
    if w_err then
      return w_res, w_err, w_type, w_path
    end

    configure()
    return reply.read_reply_index(build)
  end

  query.write_all_queries(build, function(w_res, w_err, w_type, w_path)
    if w_err then
      callback(w_res, w_err, w_type, w_path)
      return
    end

    configure(function()
      reply.read_reply_index(build, callback)
    end)
  end)
end

function all.write_configure_read(build, kind, version, configure, callback)
  if not callback then
    local w_res, w_err, w_type, w_path = query.write_query(build, kind, version)
    if w_err then
      return w_res, w_err, w_type, w_path
    end

    configure()
    return reply.read_reply(build, kind)
  end

  query.write_query(build, kind, version, function(w_res, w_err, w_type, w_path)
    if w_err then
      callback(w_res, w_err, w_type, w_path)
      return
    end

    configure(function()
      reply.read_reply(build, kind, version, callback)
    end)
  end)
end

function all.write_configure_read_codemodel(build, version, configure, callback)
  return all.write_configure_read(
    build,
    const.codemodel,
    version,
    configure,
    callback
  )
end

function all.write_configure_read_cache(build, version, configure, callback)
  return all.write_configure_read(
    build,
    const.cache,
    version,
    configure,
    callback
  )
end

function all.write_configure_read_cmake_files(
  build,
  version,
  configure,
  callback
)
  return all.write_configure_read(
    build,
    const.cmake_files,
    version,
    configure,
    callback
  )
end

function all.write_configure_read_toolchains(
  build,
  version,
  configure,
  callback
)
  return all.write_configure_read(
    build,
    const.toolchains,
    version,
    configure,
    callback
  )
end

return all
