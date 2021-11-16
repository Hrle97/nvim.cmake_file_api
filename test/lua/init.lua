_G.source = vim.g.cmake_source_path
_G.build = vim.g.cmake_build_path
_G.cmake_file_api = require "nvim.cmake_file_api"
_G.expect = require "util.expect"
_G.cmake = require "util.cmake"
_G.fun = require "util.fun"

print "NVIM LS:\n"
print(vim.fn.system { "ls", "-la", build })
print " \n"

print "NVIM ID:\n"
print(vim.fn.system { "id" })
print " \n"

local co = coroutine
local thread = nil
local done = false

local function run_units(kind, pattern)
  for _, unit_path in ipairs(vim.fn.glob(pattern, 0, 1)) do
    local unit_name = vim.fn.fnamemodify(unit_path, ":t:r")
    print("RUNNING " .. kind:upper() .. ": " .. unit_name .. " ...\n")

    vim.fn.delete(build, "rf")
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
      print("FAILED " .. kind:upper() .. ": " .. unit_name .. "\n")
      print(error)
      print "\n"
      vim.cmd [[cq]]
    else
      print("PASSED " .. kind:upper() .. ": " .. unit_name .. "\n")
      print "\n"
    end
  end
end

thread = co.create(function()
  run_units("unit test", vim.g.test_root_path .. "/lua/unit/**/*.lua")
  run_units("example", vim.g.example_root_path .. "/**/*.lua")
  vim.fn.delete(build, "rf")
  done = true
end)

co.resume(thread)
vim.wait(
  1000 * 60 * 5, -- give it 5 min max
  function()
    return done
  end,
  100 -- check every 100 ms
)
vim.cmd [[q]]
