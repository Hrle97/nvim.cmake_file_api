local query = build .. "/.cmake/api/v1/query/client-nvim/codemodel-v2"
local preply = build .. "/.cmake/api/v1/reply/index-*.json"

fs.purge(build)
expect.nay.exists(query)

cmake_file_api.write_client_stateless_query(build, "codemodel", 2)
expect.exists(query)

cmake.configure()
expect.pexists(preply)

cmake_file_api.write_client_stateless_query(build, "codemodel", 2)
expect.exists(query)

cmake.configure()
expect.pexists(preply)

local codemodel = cmake_file_api.read_reply(build, "codemodel", 2)
expect.is_object(codemodel)

local main = codemodel.data.configurations[1].targets[1].jsonFile
expect.is_lazy(main)

main = main:load()
expect.is_object(main)
