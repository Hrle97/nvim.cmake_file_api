local assert = {}

local cmake_manual_link = "https://cmake.org/cmake/help/latest/manual/"

local object_kind_link = cmake_manual_link
  .. "cmake-file-api.7.html#object-kinds"
local object_kind_assert_message = "See here: " .. object_kind_link .. "."

local callback_assert_message = "A callback should either be a Lua function"
  .. ", a Vim command string, or nil."

function assert.wrap_message(message)
  return "[nvim.cmake_file_api]: " .. message
end

function assert.ensure_dir(path, message)
  _G.assert(vim.fn.isdirectory(path), assert.wrap_message(message))

  return string.gsub(path, "/?$", "/", 1)
end

function assert.ensure_object_kind(kind, message)
  _G.assert(
    kind == "codemodel"
      or kind == "cache"
      or kind == "cmakeFiles"
      or kind == "toolchains",
    assert.wrap_message(message .. " " .. object_kind_assert_message)
  )

  return kind
end

-- TODO: better checking
function assert.ensure_object_version(_, version, message)
  _G.assert(
    type(version) == "number",
    assert.wrap_message(message .. " " .. object_kind_assert_message)
  )

  return version
end

function assert.ensure_callback_or_nil(callback, message)
  _G.assert(
    type(callback) == "function"
      or type(callback) == "nil"
      or type(callback) == "string",
    assert.wrap_message(message .. " " .. callback_assert_message)
  )

  if type(callback) == "string" then
    return function()
      vim.cmd(callback)
    end
  end

  return callback
end

return assert
