# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/myServeR_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/myServeR_autogen.dir/ParseCache.txt"
  "myServeR_autogen"
  )
endif()
