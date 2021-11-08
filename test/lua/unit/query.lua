local source = vim.g.cmake_root_path .. "/query"
local build = source .. "/.build"
local query = build .. "/.cmake/api/v1/codemodel-v2"

vim.loop.rmdir(build)

cmake_file_api.write_shared_stateless_query(build, "codemodel", 2)
expect.exists(query)
vim.system("cmake", "-S", source, "-B", build)
