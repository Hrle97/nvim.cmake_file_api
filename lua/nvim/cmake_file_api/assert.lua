local assert = {}

local fs = require "nvim.cmake_file_api.fs"

local cmake_manual_link = "https://cmake.org/cmake/help/latest/manual/"
local object_kind_link = cmake_manual_link
  .. "cmake-file-api.7.html#object-kinds"
local codemodel_object_kind_link = cmake_manual_link
  .. "cmake-file-api.7.html#object-kind-codemodel"
local cache_object_kind_link = cmake_manual_link
  .. "cmake-file-api.7.html#object-kind-cache"
local cmake_files_object_kind_link = cmake_manual_link
  .. "cmake-file-api.7.html#object-kind-cmakeFiles"
local toolchains_object_kind_link = cmake_manual_link
  .. "cmake-file-api.7.html#object-kind-toolchains"

function assert.wrap_message(...)
  local message = ""
  for i = 1, select("#", ...) do
    local current = select(i, ...)
    if current then
      message = message .. "\n" .. tostring(current)
    end
  end
  return "[nvim.cmake_file_api]:" .. (message == "" and "\nERROR" or message)
end

assert = setmetatable(assert, {
  __call = function(_, is_true, ...)
    _G.assert(is_true, assert.wrap_message(...))
  end,
})

local ensure_dir_assert_message = "Make sure that the directory exists."

function assert.ensure_dir(path, message, callback)
  path = path:gsub("/?$", "/", 1)

  if not callback then
    local ex_res, ex_err, _, _ = fs.exists(path)
    assert(not ex_err and ex_res, ensure_dir_assert_message, ex_err, message)
    return path
  end

  fs.schedule.exists(path, function(ex_res, ex_err, _, _)
    assert(not ex_err and ex_res, ensure_dir_assert_message, ex_err, message)
    callback(path)
  end)
end

local object_kind_assert_message = "See here: " .. object_kind_link .. "."

function assert.ensure_object_kind(kind, message)
  assert(
    kind == "codemodel"
      or kind == "cache"
      or kind == "cmakeFiles"
      or kind == "toolchains",
    message,
    object_kind_assert_message
  )

  return kind
end

assert.object_kind_latest_version = {
  ["codemodel"] = 2,
  ["cache"] = 2,
  ["cmakeFiles"] = 1,
  ["toolchains"] = 1,
}

-- TODO: better version checks
function assert.ensure_object_version(kind, version, message)
  assert(
    type(version) == "number"
      or type(version) == "string"
      or type(version) == "nil",
    message,
    object_kind_assert_message
  )

  return tostring(version or assert.object_kind_latest_version[kind])
end

local callback_assert_message = "A callback should either be a Lua function"
  .. ", or nil."

function assert.ensure_callback_or_nil(callback, message)
  assert(
    type(callback) == "function" or type(callback) == "nil",
    message,
    callback_assert_message
  )

  return callback
end

local reply_index_assert_message = "Reply index should be present. "
  .. "Check that you wrote a query and configured CMake before running this."

function assert.ensure_reply_index(entries)
  local reply_index = nil
  for _, entry in ipairs(entries) do
    if entry.name:match "index" then
      reply_index = entry.name
      break
    end
  end

  assert(reply_index, reply_index_assert_message)
  return reply_index
end

local reply_assert_message = "Client reply should be a table."

local client_reply_assert_message = "Reply index should contain a reply "
  .. "for the 'nvim' client. Did you forget to write a client query?"

function assert.ensure_client_reply(reply_index, message)
  assert(type(reply_index) == "table", reply_assert_message, message)
  assert(
    reply_index.data
      and type(reply_index.data) == "table"
      and reply_index.data.reply
      and type(reply_index.data.reply) == "table"
      and reply_index.data.reply["client-nvim"]
      and type(reply_index.data.reply["client-nvim"] == "table"),
    client_reply_assert_message,
    message
  )

  return reply_index.data.reply["client-nvim"]
end

local client_kind_reply_assert_message = {
  ["codemodel"] = "Client reply should contain a reply for the "
    .. '"codemodel" object kind. Did you forget to write a "codemodel" '
    .. "query or configure CMake?"
    .. "See here: "
    .. codemodel_object_kind_link,
  ["cach"] = "Client reply should contain a reply for the "
    .. '"cache" object kind. Did you forget to write a "cache" '
    .. "query or configure CMake?"
    .. "See here: "
    .. cache_object_kind_link,
  ["cmakeFiles"] = "Client reply should contain a reply for the "
    .. '"cmakeFiles" object kind. Did you forget to write a "cmakeFiles" '
    .. "query or configure CMake?"
    .. "See here: "
    .. cmake_files_object_kind_link,
  ["toolchains"] = "Client reply should contain a reply for the "
    .. '"toolchains" object kind. Did you forget to write a "toolchains" '
    .. "query or configure CMake?"
    .. "See here: "
    .. toolchains_object_kind_link,
}

function assert.ensure_client_reply_kind(client_reply, kind, version, message)
  assert(type(client_reply) == "table", reply_assert_message, message)

  local pattern = "^(" .. kind .. "%-v" .. version .. ")"
  local reply_kind = nil
  for k, v in pairs(client_reply) do
    if k:match(pattern) then
      reply_kind = v
    end
  end

  assert(
    reply_kind and reply_kind.jsonFile,
    client_kind_reply_assert_message[kind],
    message
  )

  return reply_kind
end

local query_data_message = "Client stateful queries require query data."

function assert.ensure_query_data(data, message)
  assert(type(data) == "table", query_data_message, message)

  return data
end

return assert
