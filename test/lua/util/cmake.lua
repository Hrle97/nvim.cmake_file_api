local cmake = {}

function cmake.configure(callback)
  if not callback then
    local cmd = "cmake " .. '-S "' .. source .. '" -B "' .. build .. '" '

    local handle = io.popen(cmd)
    for line in handle:lines() do
      print(line)
      local unused = function(_) end
      unused(line) -- stop unused warning
    end
    handle:close()

    return
  end

  vim.loop.spawn("cmake", {
    args = { "-S", source, "-B", build },
    stdio = { nil, 1, 2 },
    detached = false,
    hide = true,
    verbatim = false,
  }, callback)
end

return cmake
