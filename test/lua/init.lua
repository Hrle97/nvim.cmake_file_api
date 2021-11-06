local unit_test_pattern = vim.g.test_root_path .. "/lua/unit/**/*.lua"
local unit_test_paths = vim.fn.split(vim.fn.glob(unit_test_pattern))

for _, unit_test_path in ipairs(unit_test_paths) do
  local unit_test_name = vim.fn.fnamemodify(unit_test_path, ":t:r")
  print("UNIT: " .. unit_test_name)

  dofile(unit_test_path)

  vim.cmd [[ echo "\n" ]]
end

vim.cmd [[ echo "\n" ]]
