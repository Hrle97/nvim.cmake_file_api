local fs = {}

local assert = require "assert"

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
    assert(open_res, open_err)
    local dir = open_res

    local read_res, read_err = uv.fs_readdir(dir)
    assert(read_res, read_err)
    local entries = read_res

    local close_res, close_err = uv.fs_closedir(dir)
    assert(close_res, close_err)

    return entries
  end

  uv.fs_opendir(path, function(open_err, dir)
    assert(not open_err, open_err)
    uv.fs_readdir(dir, function(read_err, entries)
      assert(not read_err, read_err)
      uv.fs_closedir(dir, function(close_err, _)
        assert(not close_err, close_err)

        callback(entries)
      end)
    end)
  end, max_dir_entries)
end

function fs.exists(path, callback)
  if not callback then
    return uv.fs_stat(path)
  end

  uv.fs_stat(path, function(err, stat)
    if err then
      callback(nil)
    else
      callback(stat)
    end
  end)
end

function fs.mkdir(path, callback)
  if not callback then
    if fs.exists(path) then
      return
    end

    fs.mkdir(path:match "(.*)/.-$")
    uv.fs_mkdir(path, write_mode)
  end

  fs.exists(path, function(exists)
    if exists then
      return
    end

    fs.mkdir(path:match "(.*)/.-$", function()
      uv.fs_mkdir(path, write_mode)
    end)
  end)
end

function fs.write(path, data, callback)
  if type(data) == "table" then
    data = vim.json.encode(data)
  else
    data = tostring(data)
  end

  if not callback then
    local open_res, open_err = uv.fs_open(path, write_flags, write_mode)
    assert(open_res, open_err)
    local file = open_res

    local write_res, write_err = uv.fs_write(file, data, write_offset)
    assert(write_res, write_err)

    local close_res, close_err = uv.fs_close(file)
    assert(close_res, close_err)

    return
  end

  uv.fs_open(path, write_flags, write_mode, function(open_err, file)
    assert(not open_err, open_err)
    uv.fs_write(file, data, write_offset, function(write_err, _)
      assert(not write_err, write_err)
      uv.fs_close(file, function(close_err, _)
        assert(not close_err, close_err)
        callback()
      end)
    end)
  end)
end

function fs.touch(path, callback)
  fs.write(path, "", callback)
end

function fs.read(path, callback)
  if not callback then
    local open_res, open_err = uv.fs_open(path, read_flags, read_mode)
    assert(open_res, open_err)
    local file = open_res

    local stat_res, stat_err = uv.fs_fstat(file)
    assert(stat_res, stat_err)
    local stat = stat_res

    local read_res, read_err = uv.fs_read(file, stat.size, read_offset)
    assert(read_res, read_err)
    local json = read_res

    local close_res, close_err = uv.fs_close(file)
    assert(close_res, close_err)

    local data = vim.json.decode(json)
    return data
  end

  uv.fs_open(path, read_flags, read_mode, function(open_err, file)
    assert(not open_err, open_err)
    uv.fs_fstat(file, function(stat_err, stat)
      assert(not stat_err, stat_err)
      uv.fs_read(file, stat.size, read_offset, function(read_err, json)
        assert(not read_err, read_err)
        uv.fs_close(file, function(close_err, _)
          assert(not close_err, close_err)

          local data = vim.json.decode(json)
          callback(data)
        end)
      end)
    end)
  end)
end

return fs
