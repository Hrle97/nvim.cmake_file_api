_G.source = vim.g.cmake_source_path
_G.build = vim.g.cmake_build_path
_G.cmake_file_api = require "nvim.cmake_file_api"
_G.expect = require "util.expect"
_G.fs = require "util.fs"
_G.cmake = require "util.cmake"
_G.fun = require "util.fun"

local co = coroutine
local thread = nil

local function run_units(kind, pattern)
  for _, unit_path in ipairs(vim.fn.glob(pattern, 0, 1)) do
    local unit_name = vim.fn.fnamemodify(unit_path, ":t:r")

    fs.purge(build)
    local error = nil

    if unit_name:match "callback" then
      local unit = dofile(unit_path)
      assert(
        type(unit) == "function",
        "Callback unit " .. unit_name .. " must return a function!"
      )

      -- TODO: errors here
      unit(vim.schedule_wrap(function()
        co.resume(thread)
      end))
      co.yield()
    else
      local ran, res = pcall(dofile, unit_path)
      if not ran then
        error = res
      end
    end

    if error then
      print(kind:upper() .. ": " .. unit_name)
      print(error)
      print "\n"
      vim.cmd [[cq]]
    else
      print(kind:upper() .. ": " .. unit_name .. " PASSED")
      print "\n"
    end
  end
end

thread = co.create(function()
  run_units("unit test", vim.g.test_root_path .. "/lua/unit/**/*.lua")
  run_units("example", vim.g.example_root_path .. "/**/*.lua")
  fs.purge(build)
end)
co.resume(thread)
