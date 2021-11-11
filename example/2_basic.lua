local cmake_file_api = require "nvim.cmake_file_api"

-- write codemodel query
local did_write_query, write_query_error = cmake_file_api.write_codemodel_query(
  build
)
-- check for errors - read error handling help section
assert(did_write_query, write_query_error)

-- configure CMake
vim.fn.system {
  "cmake",
  "-S",
  source, -- your source location here
  "-B",
  build, -- your build location here
}

-- read codemodel reply
local codemodel, read_codemodel_error = cmake_file_api.read_codemodel_reply(
  build
)
assert(codemodel, read_codemodel_error) -- check for errors
expect.is_object(codemodel) -- expect is not exported - here only for testing

-- I picked the first configuration because that's what my example project looks
-- like but you might have to do a bit more work here.
local targets = codemodel.data.configurations[1].targets
-- Again, first target because my project looks like that.
-- You can load more information about the target from this lazy value.
-- If you read the CMake File API docs, this will be put in place of the
-- "jsonFile" value.
local main_target_lazy = targets[1].lazy
expect.is_lazy(main_target_lazy) -- expect not exported

-- load main target info
local main_target, main_target_error = main_target_lazy:load()
assert(main_target, main_target_error) -- check for errors
expect.is_object(main_target) -- expect not exported

-- showcase of values you can find here
expect.eq(main_target.path, main_target_lazy.path)
expect.eq(main_target.data.name, "main")
expect.eq(main_target.data.type, "EXECUTABLE")
-- you might have to do more work here to find the desired artifact
expect.eq(main_target.data.artifacts[1].path, "main")
