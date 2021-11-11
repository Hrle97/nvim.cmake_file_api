local cmake_file_api = require "nvim.cmake_file_api"

-- Every function in the CMake File API returns errors in this way.
-- If there is an error, the first returned value is nil and the rest are not
-- nil, and the reverse is true when there is no error.
local reply_index, error, error_type, error_path =
  cmake_file_api.write_configure_read_all(
    build,
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

-- The errors shown here are thrown by the luvit filesystem backend and are
-- threated as something that should be reported to the end user.
-- All other errors like passing in the wrong object kind or version or
-- attempting to read replies before a query was written or CMake was
-- configured are treated as programmer error and are asserted, so that the
-- programmer using this API catches the error and fixes their code.
-- See the error handling help section for more information.
if error then
  -- CMake File API uses luvit as a backend for the filesystem.
  -- All of these error types correspond to the names of luvit filesystem
  -- methods that throw them. This is not an exhaustive list of error types,
  -- and you should read the error handling help section for the exhaustive
  -- list.
  -- Read the luvit filesystem documentation for more information.
  -- https://github.com/luvit/luv/blob/master/docs.md#file-system-operations
  if error_type == "mkdir" then
    print("Failed to make directory at: '" .. error_path .. "'")
  elseif error_type == "opendir" then
    print("Failed to open directory at: '" .. error_path .. "'")
  elseif error_type == "readdir" then
    print("Failed to read directory at: '" .. error_path .. "'")
  elseif error_type == "closedir" then
    print("Failed to close directory at: '" .. error_path .. "'")
  elseif error_type == "open" then
    print("Failed to open file at: '" .. error_path .. "'")
  elseif error_type == "stat" then
    print("Failed to get file info at: '" .. error_path .. "'")
  elseif error_type == "read" then
    print("Failed to read file at: '" .. error_path .. "'")
  elseif error_type == "write" then
    print("Failed to write file at: '" .. error_path .. "'")
  elseif error_type == "close" then
    print("Failed to close file at: '" .. error_path .. "'")
  end

  -- Error thrown by luvit.
  -- Read the luvit documentation for more information.
  -- https://github.com/luvit/luv/blob/master/docs.md
  print("luvit error: '" .. error .. "'")
else
  expect.is_object(reply_index) -- used for testing
end
