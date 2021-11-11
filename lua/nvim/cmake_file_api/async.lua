local async = {}

local const = require "nvim.cmake_file_api.const"

function async.convert_to_scheduled(fun)
  return function(...)
    local sync_args = { ... }
    local callback = table.remove(sync_args)

    if not type(callback) == "function" then
      return fun(...)
    end

    fun(unpack(sync_args), function(...)
      local res = { ... }
      vim.schedule_wrap(function()
        callback(unpack(res))
      end)
    end)
  end
end

function async.add_scheduled(mod, name)
  if not name then
    local keys = {}
    for key, _ in pairs(mod) do
      table.insert(keys, key)
    end

    mod[const.scheduled_key] = {}
    for _, key in ipairs(keys) do
      mod[const.scheduled_key][key] = async.convert_to_scheduled(mod[key])
    end
    return
  end

  if not mod[const.scheduled_key] then
    mod[const.scheduled_key] = {}
  end

  mod[const.scheduled_key][name] = async.convert_to_scheduled(mod[name])
end

return async
