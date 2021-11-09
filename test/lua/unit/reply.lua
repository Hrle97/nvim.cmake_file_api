local source = vim.g.cmake_root_path
local build = source .. "/.build"
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

local reply = cmake_file_api.read_reply(build)
local codemodel = reply.data.objects[1].jsonFile
expect.is_object(reply)
expect.is_lazy(codemodel)

codemodel = codemodel:load()
local main = codemodel.data.configurations[1].targets[1].jsonFile
expect.is_object(codemodel)
expect.is_lazy(main)

main = main:load()
expect.is_object(main)
