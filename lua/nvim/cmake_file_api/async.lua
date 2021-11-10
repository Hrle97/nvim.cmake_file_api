local async = {}

local a = nil

if not vim.g.simulate_no_async then
  a = pcall(require, "async")
end

function async.add(mod, name, func)
  if not a then
    mod[name .. "_async"] = nil
    return
  end

  mod[name .. "_async"] = a.sync(func)
end

return async
