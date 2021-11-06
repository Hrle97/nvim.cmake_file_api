local test = {}

-- local function print_rgb(text, r, g, b)
--   print("\027[38;2;" .. r .. ";" .. g .. ";" .. b .. "m" .. text .. "\027[0m")
-- end

-- local function print_color(text, color)
--   print_rgb(text, color.r, color.g, color.b)
-- end

function test.expect(is_true, if_true, if_false)
  if is_true then
    print(if_true)
  else
    print(if_false)
    vim.cmd [[ cq ]]
  end
end

return test
