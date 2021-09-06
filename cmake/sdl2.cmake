
if(WIN32)
    CPMAddPackage(
        NAME sdl2
        URL https://www.libsdl.org/release/SDL2-devel-2.0.16-VC.zip
        VERSION 2.0.16
        DOWNLOAD_ONLY ON
    )

    if(sdl2_ADDED)
        if(NOT TARGET sdl2)
            file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS ${sdl2_SOURCE_DIR}/include/*.h)
            add_custom_target(sdl2-headers
            COMMAND ${CMAKE_COMMAND} -E rm -rf         ${sdl2_SOURCE_DIR}/include/SDL2
            COMMAND ${CMAKE_COMMAND} -E copy_directory ${sdl2_SOURCE_DIR}/include ${sdl2_SOURCE_DIR}/SDL2
            COMMAND ${CMAKE_COMMAND} -E rename         ${sdl2_SOURCE_DIR}/SDL2 ${sdl2_SOURCE_DIR}/include/SDL2
            WORKING_DIRECTORY "${sdl2_SOURCE_DIR}"
            DEPENDS ${HEADERS}
            COMMENT "COPY SDL HEADERS"
            VERBATIM
            )

            add_library(sdl2 INTERFACE)
            add_dependencies(sdl2 sdl2-headers)
            target_include_directories(sdl2 INTERFACE ${sdl2_SOURCE_DIR}/include)

            if (CMAKE_SIZEOF_VOID_P EQUAL 8)
                target_link_directories(sdl2 INTERFACE ${sdl2_SOURCE_DIR}/lib/x64)
                set(sdl2_dll ${sdl2_SOURCE_DIR}/lib/x64/SDL2.dll)
                message(NOTICE "using x64 sdl2")
            else()
                target_link_directories(sdl2 INTERFACE ${sdl2_SOURCE_DIR}/lib/x86)
                set(sdl2_dll ${sdl2_SOURCE_DIR}/lib/x86/SDL2.dll)
                message(NOTICE "using x86 sdl2")
            endif()
            target_link_libraries(sdl2 INTERFACE SDL2 SDL2main)
        endif()

        function(link_sdl2 target)
            target_link_libraries(${target} PRIVATE sdl2)
            add_custom_command(TARGET ${target} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                    ${sdl2_dll} $<TARGET_FILE_DIR:${target}>
                )
        endfunction()
    endif()
else()
    find_package(SDL2 REQUIRED)

    function(link_sdl2 target)
        target_include_directories(${target} PRIVATE ${SDL2_INCLUDE_DIRS})
        target_link_libraries(${target} PRIVATE ${SDL2_LIBRARIES})
    endfunction()
endif()
