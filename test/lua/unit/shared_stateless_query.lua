local query = build .. "/.cmake/api/v1/query/codemodel-v2"
local preply = build .. "/.cmake/api/v1/reply/index-*.json"

cmake_file_api.write_shared_stateless_query(build, "codemodel", 2)
expect.exists(query)

cmake.configure()
expect.pexists(preply)
