local expect = {}

local function print_line(content, line)
  print(("%3d: %s"):format(line, content[line]))
end

local function print_snippet(content, line)
  if line ~= 1 then
    if line ~= 2 then
      print "     ..."
    else
      print "     FILE BEGIN"
    end
    print_line(content, line - 1)
  else
    print "     FILE BEGIN"
  end

  print_line(content, line)

  if line ~= #content then
    print_line(content, line + 1)
    if line ~= #content - 1 then
      print "     ..."
    else
      print "     FILE END"
    end
  else
    print "     FILE END"
  end
end

function expect.seal(condition)
  return function(...)
    if not condition(...) then
      -- 0 getinfo
      -- 1 wrap
      -- 2 user
      local info = debug.getinfo(2)
      local source = info.source:match "^@(.*)"
      local line = info.currentline
      local content = vim.fn.readfile(source)

      print("  source: " .. source)
      print("  line: " .. line)
      print "  snippet:"
      print_snippet(content, line)

      vim.cmd [[ cq ]]
    end
  end
end

function expect.wrap(condition)
  return setmetatable({ condition = condition }, {
    __call = expect.seal(function(_, ...)
      return condition(...)
    end),
  })
end

expect = setmetatable(expect, {
  __call = expect.seal(function(_, pass)
    return pass
  end),
})

expect.nay = setmetatable({}, {
  __call = expect.seal(function(_, fail)
    return not fail
  end),
  __index = function(_, key)
    return expect.wrap(function(...)
      return not expect[key].condition(...)
    end)
  end,
})

expect.eq = expect.wrap(function(lhs, rhs)
  return lhs == rhs
end)

expect.ne = expect.wrap(function(lhs, rhs)
  return lhs ~= rhs
end)

expect.gt = expect.wrap(function(lhs, rhs)
  return lhs > rhs
end)

expect.ge = expect.wrap(function(lhs, rhs)
  return lhs >= rhs
end)

expect.lt = expect.wrap(function(lhs, rhs)
  return lhs < rhs
end)

expect.le = expect.wrap(function(lhs, rhs)
  return lhs <= rhs
end)

function expect.is(t)
  return expect.wrap(function(x)
    return type(x) == t
  end)
end

expect.is_nil = expect.is "nil"
expect.is_boolean = expect.is "boolean"
expect.is_str = expect.is "string"
expect.is_table = expect.is "table"
expect.is_function = expect.is "function"
expect.is_userdata = expect.is "userdata"
expect.is_thread = expect.is "thread"

expect.exists = expect.wrap(function(p)
  return vim.loop.fs_stat(p) ~= nil
end)

expect.pexists = expect.wrap(function(p)
  local dir_path, pattern = p:match "^(.*)/(.-)$"

  local dir = vim.loop.fs_opendir(dir_path, nil, 1024)
  local entries = vim.loop.fs_readdir(dir)
  vim.loop.fs_closedir(dir)

  pattern = pattern:gsub("%*", ".*")
  for _, entry in ipairs(entries) do
    if entry.name:match(pattern) then
      return true
    end
  end

  return false
end)

expect.is_object = expect.wrap(cmake_file_api.object.is_object)
expect.is_lazy = expect.wrap(cmake_file_api.lazy.is_lazy)

return expect
