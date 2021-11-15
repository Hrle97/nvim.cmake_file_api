local cmake_file_api = require "nvim.cmake_file_api"

local reply_index = cmake_file_api.write_configure_read_all(
  build, -- your build location here
  cmake.configure -- use vim.fn.system or vim.loop.spawn or io.popen ...
)

expect.is_object(reply_index) -- expect is not exported - just here for testing

-- read data from the reply index here!
