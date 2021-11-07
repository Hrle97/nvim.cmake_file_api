local fs = require "nvim.cmake_file_api.fs"

local object = {}
object.__index = object

local lazy = {}
lazy.__index = lazy

local function is_lazy_key(key)
  return key == "jsonFile"
end

local function get_absolute_lazy_path(relative_path, object_path)
  relative_path = string.gsub(relative_path, "^%.?/?", "", 1)
  relative_path = string.gsub(relative_path, "/?$", "/", 1)
  object_path = string.gsub(object_path, "/?$", "/", 1)

  return object_path .. relative_path
end

local function init_lazy_objects(data, object_path)
  if not type(data) == "table" then
    return
  end

  for key, value in pairs(data) do
    if is_lazy_key(key) then
      local lazy_path = get_absolute_lazy_path(value, object_path)
      data[key] = lazy:new(lazy_path)
    else
      init_lazy_objects(value, object_path)
    end
  end
end

function object:is_object(data)
  return getmetatable(data) == self
end

function object:new(path, data)
  init_lazy_objects(data, path)
  return setmetatable({ path = path, data = data }, self)
end

function lazy:is_lazy(data)
  return getmetatable(data) == self
end

function lazy:new(path)
  return setmetatable({ path = path }, self)
end

function lazy:load(callback)
  if type(callback) == "nil" then
    local data = fs.read(self.path)
    local _object = object:new(self.path, data)
    return _object
  end

  fs.read(self.path, function(data)
    local _object = object:new(self.path, data)
    callback(_object)
  end)
end

return { object = object, lazy = lazy }
