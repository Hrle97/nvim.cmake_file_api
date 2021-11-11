local cmake_file_api = require "nvim.cmake_file_api"

local reply_index = cmake_file_api.write_configure_read_all(
  build, -- your build location here
  function()
    vim.fn.system {
      "cmake",
      "-S",
      source, -- your source location here
      "-B",
      build, -- your build location here
    }
  end
)

expect.is_object(reply_index) -- expect is not exported - just here for testing

-- read data from the reply index here!
