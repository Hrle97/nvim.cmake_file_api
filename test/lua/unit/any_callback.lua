local query = build .. "/.cmake/api/v1/query/client-nvim"
local codemodel_query = query .. "/codemodel-v2"
local cache_query = query .. "/cache-v2"
local cmake_files_query = query .. "/cmakeFiles-v1"
local toolchains_query = query .. "/toolchains-v1"
local preply = build .. "/.cmake/api/v1/reply/index-*.json"

local function expect_codemodel_query(callback)
  cmake_file_api.write_query(build, "codemodel", 2, function()
    expect.exists(codemodel_query)
    callback()
  end)
end

local function expect_cache_query(callback)
  cmake_file_api.write_query(build, "cache", 2, function()
    expect.exists(cache_query)
    callback()
  end)
end

local function expect_cmake_files_query(callback)
  cmake_file_api.write_query(build, "cmakeFiles", 1, function()
    expect.exists(cmake_files_query)
    callback()
  end)
end

local function expect_toolchains_query(callback)
  cmake_file_api.write_query(build, "toolchains", 1, function()
    expect.exists(toolchains_query)
    callback()
  end)
end

local function expect_configured(callback)
  cmake.configure(function()
    expect.pexists(preply)
    callback()
  end)
end

local function expect_codemodel_reply(callback)
  cmake_file_api.read_reply(build, "codemodel", 2, function(codemodel)
    expect.is_object(codemodel)

    local main = codemodel.data.configurations[1].targets[1].jsonFile
    expect.is_lazy(main)

    main = main:load()
    expect.is_object(main)

    callback()
  end)
end

local function expect_cache_reply(callback)
  cmake_file_api.read_reply(build, "cache", 2, function(cache)
    expect.is_object(cache)
    callback()
  end)
end

local function expect_cmake_files_reply(callback)
  cmake_file_api.read_reply(build, "cmakeFiles", 1, function(cmake_files)
    expect.is_object(cmake_files)
    callback()
  end)
end

local function expect_toolchains_reply(callback)
  cmake_file_api.read_reply(build, "toolchains", 1, function(toolchains)
    expect.is_object(toolchains)
    callback()
  end)
end

return function(callback)
  fun.order(
    expect_codemodel_query,
    expect_cache_query,
    expect_cmake_files_query,
    expect_toolchains_query,

    expect_configured,

    expect_codemodel_reply,
    expect_cache_reply,
    expect_cmake_files_reply,
    expect_toolchains_reply,
    callback
  )
end
