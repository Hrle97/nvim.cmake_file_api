local cmake_file_api = require "nvim.cmake_file_api"

-- Sometimes it is easier to work with coroutines to avoid callback hell.
-- Read the coroutine documentation for more information.
-- https://www.lua.org/manual/5.1/manual.html#2.11
local thread = nil
-- callback to run something when everything is done
thread = coroutine.create(function(callback)
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

  callback() -- call callback once everything is done

  -- If you want to accept a thread you could just write:
  -- co.resume(callback, <args>...)
  -- to run something in the end.
end)

-- start the coroutine
return function(callback) -- callback to run something when everything is done
  coroutine.resume(thread, callback)
end
