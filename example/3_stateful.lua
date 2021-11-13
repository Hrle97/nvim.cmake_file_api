local cmake_file_api = require "nvim.cmake_file_api"

local did_write_query, write_query_error =
  cmake_file_api.write_client_stateful_query(
    build,
    {
      -- Put desired requests here.
      -- See the client stateful query documentation for more information.
      -- https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html#v1-client-stateful-query-files
      requests = {
        {
          kind = "codemodel",
          version = 2,
        },
      },
      -- Put whatever data you need to read from the reply later here.
      client = {
        specific = true, -- random name - no meaning behind it
      },
    }
  )
expect(did_write_query) -- here for testing
assert(did_write_query, write_query_error) -- see the error handling help

vim.fn.system {
  "cmake",
  "-S",
  source, -- your source location here
  "-B",
  build, -- your build location here
}

local index, read_index_error = cmake_file_api.read_reply_index(build)
expect.is_object(index) -- here for testing
assert(index, read_index_error) -- handle errors

-- Here is our data.
-- Client is always called "client-nvim" and stateful queries are always
-- in "query.json" when writing client queries.
local client_reply = index.data.reply["client-nvim"]["query.json"]

-- Here is the meaningless variable we set.
expect(client_reply.client.specific)

-- Here is the requested codemodel.
-- Since it is the only request we sent, it is going to be the first one.
expect.eq(client_reply.responses[1].kind, "codemodel")
