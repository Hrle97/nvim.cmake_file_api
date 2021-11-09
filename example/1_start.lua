local cmake_file_api = require "nvim.cmake_file_api"

local reply = cmake_file_api.write_configure_read(build, function()
  vim.fn.system { "cmake", "-S", source, "-B", build }
end)
expect.is_object(reply)
