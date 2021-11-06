local object = {}

local lazy = require "nvim.cmake_file_api.lazy"

object.__index = object

function object.is_object(data)
  return getmetatable(data) == object
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
    if lazy.is_lazy_key(key) then
      local lazy_path = get_absolute_lazy_path(value, object_path)
      data[key] = lazy:new(lazy_path)
    else
      init_lazy_objects(value, object_path)
    end
  end
end

function object:new(path, data)
  init_lazy_objects(data, path)
  return setmetatable({ path = path, data = data }, self)
end

-- TODO: walking utils

return object
