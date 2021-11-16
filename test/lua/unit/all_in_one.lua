local cmake_file_api = require "nvim.cmake_file_api"

local did_write_query = cmake_file_api.write_all_queries(build)
expect(did_write_query)

cmake.configure()

local reply_index = cmake_file_api.read_reply_index(build)
expect.is_object(reply_index)
