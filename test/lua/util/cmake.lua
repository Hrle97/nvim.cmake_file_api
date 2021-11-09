local cmake = {}

function cmake.configure()
  vim.fn.system { "cmake", "-S", source, "-B", build }
end

return cmake
