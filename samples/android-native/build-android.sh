# Synch data directory into Android assets
rm -rf build/android-native/app/src/main/assets/data
cp -a data build/android-native/app/src/main/assets/

# Generate C source from Nim
cd src
rm -rf cache
mkdir -p cache
# --compileOnly - only generate C source, don't try to compile it
# --cpu:arm64 --os:android - generates source for arm64-v8a, keep in sync with abiFilters in build.gradle!!
# --cpu:amd64 --os:android - generates source for x86_64, keep in sync with abiFilters in build.gradle!!
# --dynlibOverride:orxd|orxp|orx - these make sure we instead link statically and do not try to load liborx.so
# -d:androidNDK - enables Nim echo via __android_print_log
# --noMain:on - since Nim is compiling into a library we do not want a regular main
# -d:androidnative (ANDROID_NATIVE) - a flag for Norx for conditional Android native code, does not have to do with Nim
# -d:noSignalHandler - saw in another example for Android, not sure if we need this option
# -d:useMalloc - not sure if we need this option
nim c --compileOnly -d:useMalloc --dynlibOverride:orxd --dynlibOverride:orx --dynlibOverride:orxp --cpu:arm64 --os:android -d:androidNDK -d:noSignalHandler --noMain:on -d:androidnative --nimcache:$PWD/cache norxdemo.nim

# Copy C source into Android (do not remove Android.mk, Application.mk)
rm -f ../build/android-native/app/src/main/jni/*.[ch]*
cp -a cache/*.[ch]* ../build/android-native/app/src/main/jni/

# Where is lib? Copy nimbase.h from it
LIBDIR=`nim dump 2>&1 | grep '\/lib$'`
cp $LIBDIR/nimbase.h ../build/android-native/app/src/main/jni/

# Use Gradle to build
cd ../build/android-native
#gradle clean
gradle build

# Install on device
gradle installDebug
#gradle installRelease
