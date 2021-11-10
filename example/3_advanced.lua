local cmake_file_api = require "nvim.cmake_file_api"

-- NOTE: use this to configure and not vim.fn.system because Vim functions are
-- not allowed in (luv) callbacks
-- you can use this without the callback to execute CMake configuration
-- synchronously
local function configure_cmake(source, build, callback)
  -- variable only used in tests/examples
  if not vim.g.cmake_file_api_no_plenary then
    local ran, job = pcall(require, "plenary.job")
    assert(ran, "Missing plenary!")
    job
      :new({
        command = "cmake",
        args = { "-S", source, "-B", build },
        on_exit = callback,
      })
      :start()
  else
    vim.loop.spawn("cmake", {
      args = { "-S", source, "-B", build },
    }, callback)
  end
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
      -- here is our data!
      expect(index.reply["client-nvim"]["query.json"].client.specific)
      -- here is the requested codemodel
      expect.eq(
        index.reply["client-nvim"]["query.json"].responses[1].kind,
        "codemodel"
      )
    end)
  end)
end)
