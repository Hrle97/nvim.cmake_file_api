local cmake = {}

function cmake.configure()
  local cmd = 'cmake -S "' .. source .. '" -B "' .. build .. '"'

  local r = ""
  for line in io.popen(cmd):lines() do
    r = r .. line .. "\n"
  end

  return r
end

return cmake
