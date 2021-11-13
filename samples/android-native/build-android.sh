# Synch data directory into Android assets
rm -rf build/android-native/app/src/main/assets/data
cp -a data build/android-native/app/src/main/assets/

# Generate C source from Nim
cd src

TARGET_NATIVE_BASE=../build/android-native/app/src/main/jni

# ABI: armeabi-7a

rm -rf cache
mkdir -p cache
# --compileOnly - only generate C source, don't try to compile it
# --cpu:arm64 --os:android - generates source for arm64-v8a, keep in sync with abiFilters in build.gradle!!
# --cpu:arm --os:android - generates source for arm-v7a, keep in sync with abiFilters in build.gradle!!
# --cpu:amd64 --os:android - generates source for x86_64, keep in sync with abiFilters in build.gradle!!
# --dynlibOverride:orxd|orxp|orx - these make sure we instead link statically and do not try to load liborx.so
# -d:androidNDK - enables Nim echo via __android_print_log
# --noMain:on - since Nim is compiling into a library we do not want a regular main
# -d:androidnative (ANDROID_NATIVE) - a flag for Norx for conditional Android native code, does not have to do with Nim
# -d:noSignalHandler - saw in another example for Android, not sure if we need this option

# TODO: FIXME: Line below will not use the norx version specified in norxdemo.nimble but the latest
nim c --compileOnly -d:useMalloc --dynlibOverride:orxd --dynlibOverride:orx --dynlibOverride:orxp --cpu:arm --os:android -d:androidNDK -d:noSignalHandler --noMain:on -d:androidnative --nimcache:$PWD/cache norxdemo.nim

# copy only C source and include files to the Android native directory specific to ABI:
TARGET_ARM32=$TARGET_NATIVE_BASE/arm32
rm -rf $TARGET_ARM32
mkdir -p $TARGET_ARM32
cp -a cache/*.[ch]* $TARGET_ARM32

# ABI: arm64-v8a
rm -rf cache
mkdir -p cache
nim c --compileOnly -d:useMalloc --dynlibOverride:orxd --dynlibOverride:orx --dynlibOverride:orxp --cpu:arm64 --os:android -d:androidNDK -d:noSignalHandler --noMain:on -d:androidnative --nimcache:$PWD/cache norxdemo.nim

# copy only C source and include files to the Android native directory specific to ABI:
TARGET_ARM64=$TARGET_NATIVE_BASE/arm64
rm -rf $TARGET_ARM64
mkdir -p $TARGET_ARM64
cp -a cache/*.[ch]* $TARGET_ARM64

# Where is lib? Copy nimbase.h from it
LIBDIR=`nim dump 2>&1 | grep '\/lib$' | uniq`
#cp $LIBDIR/nimbase.h ../build/android-native/app/src/main/jni/
cp $LIBDIR/nimbase.h $TARGET_ARM32
cp $LIBDIR/nimbase.h $TARGET_ARM64


# Use Gradle to build
cd ../build/android-native

# clean NDK build stuff that can be problematic if NDK thinks it's up to date but isn't:
rm -rf build
rm -rf app/.cxx
rm -rf app/build

#./gradlew clean

# build all combinations of buildType and ABI_ARCH
#./gradlew build

# build Debug and Release for armeabi-v7a
#./gradlew build -Parmeabi-v7a

# build only Debug for armeabi-v7a
./gradlew assembleDebug -Parmeabi-v7a

# Install on device
echo "To install type:"
echo "cd build/android-native"
echo "./gradlew installDebug -Parmeabi-v7a"
#./gradlew installDebug -Parmeabi-v7a
#./gradle installRelease
