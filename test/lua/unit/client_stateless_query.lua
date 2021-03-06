local query = build .. "/.cmake/api/v1/query/client-nvim/codemodel-v2"
local preply = build .. "/.cmake/api/v1/reply/index-*.json"

cmake_file_api.write_client_stateless_query(build, "codemodel", 2)
expect.exists(query)

cmake.configure()
expect.pexists(preply)
