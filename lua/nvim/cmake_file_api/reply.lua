local reply = {}

local path = require "nvim.cmake_file_api.path"
local assert = require "nvim.cmake_file_api.assert"
local fs = require "nvim.cmake_file_api.fs"
local object = require("nvim.cmake_file_api.object").object

function reply.read_reply_index(build, callback)
  build = assert.ensure_dir(
    build,
    "Reading the reply index requires a valid build directory."
  )
  callback = assert.ensure_callback_or_nil(
    callback,
    "Reading the reply index requires a valid callback."
  )

  local reply_dir_path = build .. path.reply_infix

  if type(callback) == "nil" then
    local entries = fs.readdir(reply_dir_path)
    local reply_index_name = assert.ensure_reply_index(entries)
    local reply_index_path = reply_dir_path .. reply_index_name
    return object.new(reply_index_path, fs.read(reply_index_path))
  end

  fs.readdir(reply_dir_path, function(entries)
    local reply_index_entry = assert.ensure_reply_index(entries)
    local reply_index_path = reply_dir_path .. reply_index_entry
    fs.read(reply_index_path, function(data)
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
  callback = assert.ensure_callback_or_nil(
    callback,
    "Reading the reply requires a valid callback."
  )

  if not callback then
    local reply_index = reply.read_reply_index(build)
    local client_reply = assert.ensure_client_reply(reply_index)
    local kind_reply = assert.ensure_client_reply_kind(
      client_reply,
      kind,
      version
    )
    return kind_reply.jsonFile:load()
  end

  reply.read_reply_index(build, function(reply_index)
    local client_reply = assert.ensure_client_reply(reply_index)
    local kind_reply = assert.ensure_client_reply_kind(
      client_reply,
      kind,
      version
    )
    kind_reply.jsonFile:load(callback)
  end)
end

function reply.read_codemodel_reply(build, version, callback)
  return reply.read_reply(build, "codemodel", version, callback)
end

function reply.read_cache_reply(build, version, callback)
  return reply.read_reply(build, "cache", version, callback)
end

function reply.read_cmake_files_reply(build, version, callback)
  return reply.read_reply(build, "cmakeFiles", version, callback)
end

function reply.read_toolchains_reply(build, version, callback)
  return reply.read_reply(build, "toolchains", version, callback)
end

return reply