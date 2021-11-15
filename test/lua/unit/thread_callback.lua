local co = coroutine
local cmake_file_api = require "nvim.cmake_file_api"

local thread = nil
thread = co.create(function(callback)
  cmake_file_api.write_codemodel_query(build, cmake_file_api.latest, thread)
  local did_write = co.yield()
  expect(did_write)

  cmake.configure(function()
    co.resume(thread)
  end)
  co.yield()

  cmake_file_api.read_codemodel_reply(build, cmake_file_api.latest, thread)
  local codemodel = co.yield()
  expect.is_object(codemodel)

  callback()
end)

return function(callback)
  co.resume(thread, callback)
end
