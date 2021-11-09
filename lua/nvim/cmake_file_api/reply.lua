local reply = {}

local path = require "nvim.cmake_file_api.path"
local assert = require "nvim.cmake_file_api.assert"
local fs = require "nvim.cmake_file_api.fs"
local object = require("nvim.cmake_file_api.object").object

function reply.read_reply(build, callback)
  build = assert.ensure_dir(build, "Reply requires a valid build directory.")
  callback = assert.ensure_callback_or_nil(
    callback,
    "Reply requires a valid callback."
  )

  local reply_dir_path = build .. path.reply_infix

  if type(callback) == "nil" then
    for _, entry in ipairs(fs.readdir(reply_dir_path)) do
      if string.match(entry.name, "^index") then
        local _path = reply_dir_path .. entry.name
        local data = fs.read(_path)
        local _object = object.new(_path, data)
        return _object
      end
    end
  end

  fs.readdir(reply_dir_path, function(entries)
    for _, entry in ipairs(entries) do
      if string.match(entry.name, "^index") then
        local _path = reply_dir_path .. entry.name
        fs.read(_path, function(data)
          local _object = object.new(_path, data)
          callback(_object)
        end)
      end
    end
  end)
end

return reply