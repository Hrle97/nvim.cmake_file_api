local query = build .. "/.cmake/api/v1/query/codemodel-v2"
local preply = build .. "/.cmake/api/v1/reply/index-*.json"

fs.purge(build)
expect.nay.exists(query)

cmake_file_api.write_shared_stateless_query(build, "codemodel", 2)
expect.exists(query)

vim.fn.system { "cmake", "-S", source, "-B", build }
expect.pexists(preply)

cmake_file_api.write_shared_stateless_query(build, "codemodel", 2)
expect.exists(query)

vim.fn.system { "cmake", "-S", source, "-B", build }
expect.pexists(preply)
