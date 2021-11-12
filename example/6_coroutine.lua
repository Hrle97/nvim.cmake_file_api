local cmake_file_api = require "nvim.cmake_file_api"

-- Sometimes it is easier to work with coroutines to avoid callback hell.
-- Read the coroutine documentation for more information.
-- https://www.lua.org/manual/5.1/manual.html#2.11
local thread = nil
thread = coroutine.create(function()
  cmake_file_api.write_cmake_files_query(
    build,
    cmake_file_api.latest,
    thread -- pass your thread to resume it once the query is written
  )
  local did_write = coroutine.yield() -- wait until the query gets written
  expect(did_write) -- used for testing - do your error handling here

  vim.loop.spawn("cmake", {
    args = {
      "-S",
      source, -- source location here
      "-B",
      build, -- build location here
    },
  }, function()
    coroutine.resume(thread) -- resume thread once CMake is configured
  end)
  coroutine.yield() -- wait until CMake configures

  cmake_file_api.read_cmake_files_reply( -- read the reply
    build,
    cmake_file_api.latest,
    thread -- pass your thread to resume it once the reply is read
  )
  local reply = coroutine.yield() -- wait until the reply is read
  expect.is_object(reply) -- used for testing - do your error handling here
end)

-- start the coroutine
coroutine.resume(thread)
