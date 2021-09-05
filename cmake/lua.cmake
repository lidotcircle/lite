CPMAddPackage(
    NAME lua
    GITHUB_REPOSITORY lua/lua
    DOWNLOAD_ONLY YES
    VERSION 5.2.3
)

if (lua_ADDED)
  FILE(GLOB lua_sources ${lua_SOURCE_DIR}/*.c)
  FILE(GLOB lua_headers ${lua_SOURCE_DIR}/*.h)
  list(REMOVE_ITEM lua_sources
    "${lua_SOURCE_DIR}/lua.c"
    "${lua_SOURCE_DIR}/ltests.c"
    "${lua_SOURCE_DIR}/onelua.c"
  )

  add_custom_target(lua-sdk
    COMMAND ${CMAKE_COMMAND} -E make_directory ${lua_SOURCE_DIR}/include/lua
    COMMAND ${CMAKE_COMMAND} -E copy ${lua_SOURCE_DIR}/lua.h     ${lua_SOURCE_DIR}/include/lua
    COMMAND ${CMAKE_COMMAND} -E copy ${lua_SOURCE_DIR}/luaconf.h ${lua_SOURCE_DIR}/include/lua
    COMMAND ${CMAKE_COMMAND} -E copy ${lua_SOURCE_DIR}/lauxlib.h ${lua_SOURCE_DIR}/include/lua
    COMMAND ${CMAKE_COMMAND} -E copy ${lua_SOURCE_DIR}/lualib.h  ${lua_SOURCE_DIR}/include/lua
    WORKING_DIRECTORY "${lua_SOURCE_DIR}"
    DEPENDS ${lua_headers}
    COMMENT "COPY LUA HEADERS"
    VERBATIM
  )

  add_library(lua STATIC ${lua_sources})
  target_include_directories(lua PUBLIC $<BUILD_INTERFACE:${lua_SOURCE_DIR}/include>)

  function (link_lua target)
    add_dependencies(${target} lua)
    add_dependencies(${target} lua-sdk)
    target_link_libraries(${target} PRIVATE lua)
  endfunction()
endif()
