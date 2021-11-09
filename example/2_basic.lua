local cmake_file_api = require "nvim.cmake_file_api"

-- write codemodel query
cmake_file_api.write_codemodel_query(build)

-- configure CMake
vim.fn.system { "cmake", "-S", source, "-B", build }

-- read codemodel reply
local codemodel = cmake_file_api.read_codemodel_reply(build)
expect.is_object(codemodel)

-- get main target info
local targets = codemodel.data.configurations[1].targets
local main_target_lazy = targets[1].jsonFile
expect.is_lazy(main_target_lazy)

-- load main target info
local main_target = main_target_lazy:load()
expect.is_object(main_target)
expect.eq(main_target.path, main_target_lazy.path)
expect.eq(main_target.data.name, "main")
expect.eq(main_target.data.type, "EXECUTABLE")
expect.eq(main_target.data.artifacts[1].path, "main")
