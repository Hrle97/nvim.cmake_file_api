local cmake = {}

function cmake.configure(callback)
  if not callback then
    local cmd = 'cmake -S "' .. source .. '" -B "' .. build .. '"'
    local r = ""
    for line in io.popen(cmd):lines() do
      r = r .. line .. "\n"
    end
    return r
  end

  vim.loop.spawn("cmake", {
    args = { "-S", source, "-B", build },
  }, callback)
end

return cmake
