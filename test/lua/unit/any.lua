local query = build .. "/.cmake/api/v1/query/client-nvim"
local codemodel_query = query .. "/codemodel-v2"
local cache_query = query .. "/cache-v2"
local cmake_files_query = query .. "/cmakeFiles-v1"
local toolchains_query = query .. "/toolchains-v1"
local preply = build .. "/.cmake/api/v1/reply/index-*.json"

cmake_file_api.write_query(build, "codemodel", 2)
expect.exists(codemodel_query)

cmake_file_api.write_query(build, "cache", 2)
expect.exists(cache_query)

cmake_file_api.write_query(build, "cmakeFiles", 1)
expect.exists(cmake_files_query)

cmake_file_api.write_query(build, "toolchains", 1)
expect.exists(toolchains_query)

cmake.configure()
expect.pexists(preply)

local codemodel = cmake_file_api.read_reply(build, "codemodel", 2)
expect.is_object(codemodel)

local main = codemodel.data.configurations[1].targets[1].jsonFile
expect.is_lazy(main)

main = main:load()
expect.is_object(main)

local cache = cmake_file_api.read_reply(build, "cache", 2)
expect.is_object(cache)

local cmake_files = cmake_file_api.read_reply(build, "cmakeFiles", 1)
expect.is_object(cmake_files)

local toolchains = cmake_file_api.read_reply(build, "toolchains", 1)
expect.is_object(toolchains)
