local query = build .. "/.cmake/api/v1/query/client-nvim/query.json"
local preply = build .. "/.cmake/api/v1/reply/index-*.json"

fs.purge(build)
expect.nay.exists(query)

cmake_file_api.write_client_stateful_query(
  build,
  { requests = { { kind = "codemodel", version = 2 } } }
)
expect.exists(query)

cmake.configure()
expect.pexists(preply)

cmake_file_api.write_client_stateful_query(
  build,
  { requests = { { kind = "codemodel", version = 2 } } }
)
expect.exists(query)

cmake.configure()
expect.pexists(preply)
