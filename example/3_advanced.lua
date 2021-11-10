local cmake_file_api = require "nvim.cmake_file_api"

local uv = vim.loop

-- NOTE: use this to configure and not vim.fn.system because Vim functions are
-- not allowed in (luv) callbacks
-- you can use this without the callback to execute CMake configuration
-- synchronously
local function configure_cmake(source, build, callback)
  -- with plenary:
  -- require("plenary.job")
  --   :new({
  --     command = "cmake",
  --     args = { "-S", source, "-B", build },
  --     on_exit = callback,
  --   })
  --   :start()
  -- with uv:
  uv.spawn("cmake", {
    args = { "-S", source, "-B", build },
  }, callback)
end

cmake_file_api.write_client_stateful_query(build, {
  requests = {
    {
      kind = "codemodel",
      version = 2,
    },
  },
  -- put whatever data you need to read from the reply later here
  client = {
    specific = true, -- random name - no meaning behind it
  },
}, function()
  configure_cmake(source, build, function()
    cmake_file_api.read_reply_index(build, function(index)
      expect.is_object(index)
    end)
  end)
end)
