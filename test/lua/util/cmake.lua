local cmake = {}

function cmake.configure()
  print(source)
  print(build)
  vim.fn.system { "cmake", "-S", source, "-B", build }
end

return cmake
