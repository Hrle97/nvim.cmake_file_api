local reply = {}

local const = require "nvim.cmake_file_api.const"
local assert = require "nvim.cmake_file_api.assert"
local fs = require "nvim.cmake_file_api.fs"
local object = require("nvim.cmake_file_api.object").object
local async = require "nvim.cmake_file_api.async"

function reply.read_reply_index(build, callback)
  build = assert.ensure_dir(
    build,
    "Reading the reply index requires a valid build directory."
  )
  callback = assert.ensure_callback_or_nil(
    callback,
    "Reading the reply index requires a valid callback."
  )

  local reply_dir_path = build .. const.reply_infix

  if type(callback) == "nil" then
    local rd_res, rd_err, rd_type, rd_path = fs.readdir(reply_dir_path)
    if rd_err then
      return rd_res, rd_err, rd_type, rd_path
    end
    local entries = rd_res

    local reply_index_name = assert.ensure_reply_index(entries)
    local reply_index_path = reply_dir_path .. reply_index_name

    local r_res, r_err, r_type, r_path = fs.read(reply_index_path)
    if r_err then
      return r_res, r_err, r_type, r_path
    end
    local data = r_res

    return object.new(reply_index_path, data)
  end

  fs.readdir(reply_dir_path, function(rd_res, rd_err, rd_type, rd_path)
    if rd_err then
      callback(rd_res, rd_err, rd_type, rd_path)
      return
    end
    local entries = rd_res

    local reply_index_entry = assert.ensure_reply_index(entries)
    local reply_index_path = reply_dir_path .. reply_index_entry

    fs.read(reply_index_path, function(r_res, r_err, r_type, r_path)
      if r_err then
        callback(r_res, r_err, r_type, r_path)
        return
      end
      local data = r_res

      callback(object.new(reply_index_path, data))
    end)
  end)
end

function reply.read_reply(build, kind, version, callback)
  build = assert.ensure_dir(
    build,
    "Reading the reply requires a valid build directory."
  )
  kind = assert.ensure_object_kind(
    kind,
    "Reading the reply requires a valid object kind."
  )
  version = assert.ensure_object_version(
    kind,
    version,
    "Reading the reply requires a valid object version."
  )

  if not callback then
    local r_res, r_err, r_type, r_path = reply.read_reply_index(build)
    if r_err then
      return r_res, r_err, r_type, r_path
    end
    local reply_index = r_res

    local client_reply = assert.ensure_client_reply(reply_index)
    local kind_reply = assert.ensure_client_reply_kind(
      client_reply,
      kind,
      version
    )

    return kind_reply[const.new_lazy_key]:load()
  end
  callback = assert.ensure_callback_or_nil(
    callback,
    "Reading the reply requires a valid callback."
  )

  reply.read_reply_index(build, function(r_res, r_err, r_type, r_path)
    if r_err then
      callback(r_res, r_err, r_type, r_path)
      return
    end
    local reply_index = r_res

    local client_reply = assert.ensure_client_reply(reply_index)
    local kind_reply = assert.ensure_client_reply_kind(
      client_reply,
      kind,
      version
    )

    kind_reply[const.new_lazy_key]:load(callback)
  end)
end

function reply.read_codemodel_reply(build, version, callback)
  return reply.read_reply(build, const.codemodel, version, callback)
end

function reply.read_cache_reply(build, version, callback)
  return reply.read_reply(build, const.cache, version, callback)
end

function reply.read_cmake_files_reply(build, version, callback)
  return reply.read_reply(build, const.cmake_files, version, callback)
end

function reply.read_toolchains_reply(build, version, callback)
  return reply.read_reply(build, const.toolchains, version, callback)
end

async.add_scheduled(reply)
return reply