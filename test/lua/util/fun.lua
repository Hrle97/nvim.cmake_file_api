local fun = {}

function fun.order(head, ...)
  if not head then
    return
  end

  local rest = { ... }
  if #rest == 0 then
    head()
  else
    head(function()
      fun.order(unpack(rest))
    end)
  end
end

return fun
