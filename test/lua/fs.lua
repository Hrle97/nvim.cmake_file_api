local fs = {}

local uv = vim.loop

function fs.purge(p)
  local scan = uv.fs_scandir(p)
  if not scan then
    return
  end

  local name, type = uv.fs_scandir_next(scan)
  while name do
    if type == "directory" then
      fs.purge(p:match "^(.-)/?$" .. "/" .. name)
    else
      vim.fn.delete(p:match "^(.-)/?$" .. "/" .. name)
    end
    name, type = uv.fs_scandir_next(scan)
  end

  uv.fs_rmdir(p)
end

return fs
