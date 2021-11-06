local lazy = {}

local object = require "nvim.cmake_file_api.object"
local fs = require "nvim.cmake_file_api.fs"

lazy.__index = lazy

function lazy.is_lazy_key(key)
  return key == "jsonFile"
end

function lazy.is_lazy(data)
  return getmetatable(data) == lazy
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

return lazy
