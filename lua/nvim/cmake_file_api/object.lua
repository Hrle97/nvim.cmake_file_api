local const = require "nvim.cmake_file_api.const"
local fs = require "nvim.cmake_file_api.fs"

local object = {}
object.__index = object

local lazy = {}
lazy.__index = lazy

local function init_lazy_objects(data, object_dir)
  if not (type(data) == "table") then
    return
  end

  local keys = {}
  for key, _ in pairs(data) do
    table.insert(keys, key)
  end

  for _, key in ipairs(keys) do
    if key == const.old_lazy_key then
      data[const.new_lazy_key] = lazy:new(
        object_dir .. data[const.old_lazy_key]
      )
      data[const.old_lazy_key] = nil
    else
      init_lazy_objects(data[key], object_dir)
    end
  end
end

function object.is_object(data)
  return getmetatable(data) == object
end

function object.new(path, data)
  init_lazy_objects(data, path:gsub("^(.*)/.-$", "%1/"))
  return setmetatable({ path = path, data = data }, object)
end

function lazy.is_lazy(data)
  return getmetatable(data) == lazy
end

function lazy:new(path)
  return setmetatable({ path = path }, self)
end

function lazy:load(callback)
  local path = self.path

  if not callback then
    local read_res, read_err, read_type, read_path = fs.read(path)
    if read_err then
      return read_res, read_err, read_type, read_path
    end

    return object.new(path, read_res)
  end

  fs.read(path, function(read_res, read_err, read_type, read_path)
    if read_err then
      callback(read_res, read_err, read_type, read_path)
      return
    end

    callback(object.new(path, read_res))
  end)
end

return { object = object, lazy = lazy }
