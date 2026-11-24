cmake_minimum_required(VERSION 3.25)

# This is deliberately a separate target.  The original .vcxproj remains the
# authoritative Windows/Xbox build definition and is not imported or edited.
project(MinecraftClientIOS LANGUAGES CXX OBJCXX)

if(NOT APPLE)
    message(FATAL_ERROR "MinecraftClientIOS must be configured on macOS with Xcode.")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_OSX_ARCHITECTURES arm64 CACHE STRING "iOS device architecture")
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "15.0")
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED "NO")
set(CMAKE_XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.minecraftconsole.clientios")

set(MC_IOS_HOST_SOURCES
    App/MCAppDelegate.mm
    App/MCGameViewController.mm
    Platform/MCIOSPlatform.mm
    Platform/MCMetalRenderer.mm
)

add_executable(MinecraftClientIOSHost MACOSX_BUNDLE ${MC_IOS_HOST_SOURCES})
target_include_directories(MinecraftClientIOSHost PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_definitions(MinecraftClientIOSHost PRIVATE
    MC_IOS_PORT=1
    MC_IOS_SHARED_CORE_AVAILABLE=0
)
target_link_libraries(MinecraftClientIOSHost PRIVATE
    "-framework UIKit"
    "-framework Metal"
    "-framework MetalKit"
    "-framework QuartzCore"
    "-framework GameController"
    "-framework AVFoundation"
)
set_target_properties(MinecraftClientIOSHost PROPERTIES
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/App/Info.plist.in"
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2"
)

# The source manifest documents the exact common-code boundary.  It is not
# linked until its Windows API, D3D/Iggy, and Miles dependencies have genuine
# iOS implementations; building a host-only shell as if it were the game
# would make CI misleading.
include(SharedCoreSources.cmake)
