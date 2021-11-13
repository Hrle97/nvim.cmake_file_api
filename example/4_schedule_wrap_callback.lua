local cmake_file_api = require "nvim.cmake_file_api"

return function(callback) -- use the callback to run something at the very end
  -- Using the cache query as an example.
  cmake_file_api.write_cache_query(
    build, -- your build location here
    -- use latest for readability when you don't care about the version
    cmake_file_api.latest,
    -- If you want to use Vim functions in callbacks, you have to use
    -- vim.schedule_wrap.
    vim.schedule_wrap(function(did_write_query, write_query_error)
      expect(did_write_query) -- here for testing
      assert(did_write_query, write_query_error) -- handle errors

      -- For example, use vim.fn.system to configure CMake!
      vim.fn.system {
        "cmake",
        "-B",
        build, -- your build location here
        "-S",
        source, -- your source location here
      }

      -- Read the reply from the CMake File API.
      cmake_file_api.read_cache_reply(
        build, -- your build location here
        cmake_file_api.latest,
        function(cache, cache_error)
          expect.is_object(cache)
          assert(cache, cache_error)

          expect.nay.is_nil(cache.data.entries) -- cache entries are here

          callback()
        end
      )
    end)
  )
end
