# Gradle uses abiFilters instead, in build.gradle. But if you run ndk-build manually it needs to be defined here too.
APP_ABI := armeabi-v7a # armeabi-v7a arm64-v8a
APP_MODULES := norxdemo
NDK_TOOLCHAIN_VERSION := clang
APP_PLATFORM := android-19
# Only add for Nim cpp
# APP_STL := c++_shared
