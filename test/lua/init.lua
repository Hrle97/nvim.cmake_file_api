_G.source = vim.g.cmake_source_path
_G.cmake_file_api = require "nvim.cmake_file_api"
_G.expect = require "util.expect"
_G.fs = require "util.fs"
_G.cmake = require "util.cmake"
_G.fun = require "util.fun"

_G.__WAIT = false
_G.__ERROR = nil

local function run_units(kind, pattern)
  for _, unit_path in ipairs(vim.fn.glob(pattern, 0, 1)) do
    local unit_name = vim.fn.fnamemodify(unit_path, ":t:r")
    print("RUNNING " .. kind:upper() .. ": " .. unit_name)

    _G.build = vim.g.cmake_build_path .. "_" .. unit_name
    fs.purge(build)
    _G.__ERROR = nil

    if unit_name:match "callback" then
      local unit = dofile(unit_path)
      assert(
        type(unit) == "function",
        "Callback unit " .. unit_name .. " must return a function!"
      )

      _G.__WAIT = true
      unit(function(err)
        _G.__WAIT = false
        _G.__ERROR = err
      end)

      while _G.__WAIT do
        vim.loop.sleep(10)
      end
    else
      local ran, res = pcall(dofile, unit_path)
      if not ran then
        _G.__ERROR = res
      end
    end

    if _G.__ERROR then
      print(kind:upper() .. ": " .. unit_name)
      print(_G.__ERROR)
      vim.cmd [[cq]]
    elseif not unit_name:match "callback$" then
      print(kind:upper() .. ": " .. unit_name .. " PASSED")
    end
  end
end

run_units("unit test", vim.g.test_root_path .. "/lua/unit/**/*.lua")
run_units("example", vim.g.example_root_path .. "/**/*.lua")
