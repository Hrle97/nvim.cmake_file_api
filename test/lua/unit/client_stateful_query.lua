local source = vim.g.cmake_root_path
local build = source .. "/.build"
local query = build .. "/.cmake/api/v1/query/client-nvim/query.json"
local preply = build .. "/.cmake/api/v1/reply/index-*.json"

fs.purge(build)
expect.nay.exists(query)

cmake_file_api.write_client_stateful_query(
  build,
  { requests = { { kind = "codemodel", version = 2 } } }
)
expect.exists(query)

vim.fn.system { "cmake", "-S", source, "-B", build }
expect.pexists(preply)

cmake_file_api.write_client_stateful_query(
  build,
  { requests = { { kind = "codemodel", version = 2 } } }
)
expect.exists(query)

vim.fn.system { "cmake", "-S", source, "-B", build }
expect.pexists(preply)
