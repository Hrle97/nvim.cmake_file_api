local fs = {}

local uv = vim.loop

local offset = 0

local write_flags = "w"
local write_mode = 438 -- rwxrwxrw
local write_offset = offset

local read_flags = "r"
local read_mode = 292 -- rwxrwxrw
local read_offset = offset

local max_dir_entries = 1024

function fs.readdir(path, callback)
  if not callback then
    local open_res, open_err = uv.fs_opendir(path, nil, max_dir_entries)
    if open_err then
      return nil, open_err, "opendir", path
    end
    local dir = open_res

    local read_res, read_err = uv.fs_readdir(dir)
    if read_err then
      return nil, read_err, "readdir", path
    end
    local entries = read_res

    local _, close_err = uv.fs_closedir(dir)
    if close_err then
      return nil, close_err, "closedir", path
    end

    return entries
  end

  uv.fs_opendir(path, function(open_err, dir)
    if open_err then
      callback(nil, open_err, "opendir", path)
      return
    end

    uv.fs_readdir(dir, function(read_err, entries)
      if read_err then
        callback(nil, read_err, "readdir", path)
        return
      end

      uv.fs_closedir(dir, function(close_err, _)
        if close_err then
          callback(nil, close_err, "closedir", path)
          return
        end

        callback(entries)
      end)
    end)
  end, max_dir_entries)
end

function fs.exists(path, callback)
  if not callback then
    local _, stat_err = uv.fs_stat(path)
    if stat_err then
      return nil, stat_err, "stat", path
    end

    return path
  end

  uv.fs_stat(path, function(stat_err, _)
    if stat_err then
      callback(nil, stat_err, "stat", path)
      return
    end

    callback(path)
  end)
end

function fs.mkdir(path, callback)
  if not callback then
    if fs.exists(path) then
      return path
    end

    local head = path:match("(.-)/?$"):match "(.*)/.-$"
    fs.mkdir(head)

    local _, mkdir_err = uv.fs_mkdir(path, write_mode)
    if mkdir_err then
      return nil, mkdir_err, "mkdir", path
    end

    return path
  end

  fs.exists(path, function(exists)
    if exists then
      callback(path)
      return
    end

    local head = path:match("(.-)/?$"):match "(.*)/.-$"
    fs.mkdir(head, function()
      uv.fs_mkdir(path, write_mode, function(mkdir_err, _)
        if mkdir_err then
          callback(nil, mkdir_err, "mkdir", path)
          return
        end

        callback(path)
      end)
    end)
  end)
end

function fs.write(path, data, callback)
  if not callback then
    local open_res, open_err = uv.fs_open(path, write_flags, write_mode)
    if open_err then
      return nil, open_err, "open", path
    end
    local file = open_res

    if type(data) == "table" then
      data = vim.json.encode(data)
    else
      data = tostring(data)
    end

    local _, write_err = uv.fs_write(file, data, write_offset)
    if write_err then
      return nil, write_err, "write", path
    end

    local _, close_err = uv.fs_close(file)
    if close_err then
      return nil, close_err, "close", path
    end

    return path
  end

  uv.fs_open(path, write_flags, write_mode, function(open_err, file)
    if open_err then
      callback(nil, open_err, "open", path)
      return
    end

    if type(data) == "table" then
      data = vim.json.encode(data)
    else
      data = tostring(data)
    end

    uv.fs_write(file, data, write_offset, function(write_err, _)
      if write_err then
        callback(nil, write_err, "write", path)
        return
      end

      uv.fs_close(file, function(close_err, _)
        if close_err then
          callback(nil, close_err, "close", path)
          return
        end

        callback(path)
      end)
    end)
  end)
end

function fs.touch(path, callback)
  return fs.write(path, "", callback)
end

function fs.read(path, callback)
  if not callback then
    local open_res, open_err = uv.fs_open(path, read_flags, read_mode)
    if open_err then
      return nil, open_err, "open", path
    end
    local file = open_res

    local stat_res, stat_err = uv.fs_fstat(file)
    if stat_err then
      return nil, stat_err, "stat", path
    end
    local stat = stat_res

    local read_res, read_err = uv.fs_read(file, stat.size, read_offset)
    if read_err then
      return nil, read_err, "read", path
    end
    local json = read_res

    local _, close_err = uv.fs_close(file)
    if close_err then
      return nil, close_err, "close", path
    end

    local data = vim.json.decode(json)
    return data
  end

  uv.fs_open(path, read_flags, read_mode, function(open_err, file)
    if open_err then
      callback(nil, open_err, "open", path)
      return
    end

    uv.fs_fstat(file, function(stat_err, stat)
      if stat_err then
        callback(nil, stat_err, "stat", path)
        return
      end

      uv.fs_read(file, stat.size, read_offset, function(read_err, json)
        if read_err then
          callback(nil, read_err, "read", path)
          return
        end

        uv.fs_close(file, function(close_err, _)
          if close_err then
            callback(nil, close_err, "close", path)
            return
          end

          local data = vim.json.decode(json)
          callback(data)
        end)
      end)
    end)
  end)
end

return fs
