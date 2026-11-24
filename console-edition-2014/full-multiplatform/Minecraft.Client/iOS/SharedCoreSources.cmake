# Source inventory for the future MinecraftClientIOSCore target.
#
# The list is derived from the two original project roots, deliberately
# excluding every existing platform implementation.  Keeping this inventory
# separate makes the port's reuse boundary reviewable while avoiding a false
# successful build that silently omits game systems.
file(GLOB_RECURSE MC_WORLD_COMMON CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/../../Minecraft.World/*.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/../../Minecraft.World/*.c")
file(GLOB_RECURSE MC_CLIENT_COMMON CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/../*.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/../*.c")

set(MC_PLATFORM_PATHS
    "/Windows64/" "/Xbox/" "/Durango/" "/PS3/" "/Orbis/" "/PSVita/"
    "/iOS/")
foreach(path IN LISTS MC_PLATFORM_PATHS)
    list(FILTER MC_CLIENT_COMMON EXCLUDE REGEX ".*${path}.*")
endforeach()

# These are real shared game sources, not substitute implementations.  The
# target is EXCLUDE_FROM_ALL until the platform compatibility layer supports
# their compile requirements; enable it explicitly to expose the next porting
# errors rather than hide them.
add_library(MinecraftClientIOSCore EXCLUDE_FROM_ALL STATIC
    ${MC_WORLD_COMMON}
    ${MC_CLIENT_COMMON})
target_include_directories(MinecraftClientIOSCore PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/../.."
    "${CMAKE_CURRENT_LIST_DIR}/../../Minecraft.World"
    "${CMAKE_CURRENT_LIST_DIR}/..")
target_compile_definitions(MinecraftClientIOSCore PRIVATE
    MC_IOS_PORT=1
    __IOS__=1
    _LARGE_WORLDS=1)

message(STATUS "MinecraftClientIOSCore inventories ${MC_WORLD_COMMON} world sources and ${MC_CLIENT_COMMON} client sources")
