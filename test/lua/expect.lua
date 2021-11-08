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

function expect.wrap(condition)
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

expect = setmetatable(expect, {
  __call = expect.wrap(function(_, pass)
    return pass
  end),
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

function expect.exists(p)
  return vim.fn.filereadable(p) == 1
end

function expect.pexists(p)
  return #vim.fn.glob(p, 0, 1) ~= 0
end

return expect
