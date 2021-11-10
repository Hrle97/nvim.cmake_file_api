local unit_test_pattern = vim.g.test_root_path .. "/lua/unit/**/*.lua"
local unit_test_paths = vim.fn.glob(unit_test_pattern, 0, 1)

local example_pattern = vim.g.example_root_path .. "/**/*.lua"
local example_paths = vim.fn.glob(example_pattern, 0, 1)

_G.build = vim.g.cmake_build_path
_G.source = vim.g.cmake_source_path
_G.cmake_file_api = require "nvim.cmake_file_api"
_G.expect = require "util.expect"
_G.fs = require "util.fs"
_G.fun = require "util.fun"
_G.cmake = require "util.cmake"

for _, unit_test_path in ipairs(unit_test_paths) do
  local unit_test_name = vim.fn.fnamemodify(unit_test_path, ":t:r")

  fs.purge(build)

  local ran, res = pcall(dofile, unit_test_path)
  if not ran then
    print("UNIT: " .. unit_test_name)
    vim.cmd [[ echo "\n" ]]
    print(res)
    vim.cmd [[ echo "\n" ]]
    vim.cmd [[cq]]
  else
    print("UNIT: " .. unit_test_name .. " PASSED")
    vim.cmd [[ echo "\n" ]]
  end
end

for _, example_path in ipairs(example_paths) do
  local example_name = vim.fn.fnamemodify(example_path, ":t:r")

  fs.purge(build)

  local ran, res = pcall(dofile, example_path)
  if not ran then
    print("EXAMPLE: " .. example_name)
    vim.cmd [[ echo "\n" ]]
    print(res)
    vim.cmd [[ echo "\n" ]]
    vim.cmd [[cq]]
  else
    print("EXAMPLE: " .. example_name .. " PASSED")
    vim.cmd [[ echo "\n" ]]
  end
end

fs.purge(build)
