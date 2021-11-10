local fun = {}

function fun.order(head, ...)
  if not head then
    return
  end

  local rest = { ... }
  head(function()
    fun.order(unpack(rest))
  end)
end

return fun
