# Norxdemo
Just a template for Android.

# Nim, ORX and Norx
First follow instructions at [Norx wrapper](https://github.com/gokr/norx) to get ORX, Nim and Norx installed.

# Build and run
Currently the easiest way to just build and run on Linux/OSX:

        nimble run norxdemo

Or to only build:

        nimble build

More manually to make a release binary:

        cd src
        nim c -d:release -o:../norxdemo norxdemo.nim

...or a debug build:

        cd src
        nim c -o:../norxdemod norxdemo.nim

The reason to use `norxdemo` for a release build, `norxdemod` for a debug build and `norxdemop` for a profile build is because the executable name affects
how ORX picks ini-files from the `data/config` directory and it also affects which `liborx.so|.dylib|.dll` it will load when it runs.

# Android
Currently we build for Android by using an Android NDK project structure originally copied from the android-native demo in ORX, and modified a bit.

First make sure you have ORX env var set to the "code" directory of your ORX git clone. Then make sure you have Android SDKs installed, typically done via Android Studio and
ANDROID_HOME set to point to your Sdk, like for example:

        ANDROID_HOME=/home/gokr/Android/Sdk/

You also want PATH set to these (`adb` etc):

        /home/gokr/Android/Sdk/platform-tools:/home/gokr/Android/Sdk/tools/bin:/home/gokr/Android/Sdk/build-tools/28.0.0

Then build static ORX libraries for android-native:

        cd $ORX/build/android-native
        ndk-build clean
        ndk-build
        ./install.sh

That compiles libraries for all binary Android platforms, but we currently only use armv8.

Then go back to norxdemo and build (generate C code and produce debug and release APKs) using:

        ./build-android.sh

This will:

* Mirror the data directory into the build/android-native/app/src/main/assets directory.
* Generate and copy C sources from Nim into build/android-native/app/src/main/jni
* Go into build/android-native and call "gradle build" to make debug and release APKs

Note that this produces norxdemo.so (statically linked with liborx) into an APK with MainActivity.java etc.

You can then from android-native do:

        gradle installDebug
        gradle uninstallDebug
        gradle installRelease
        gradle uninstallRelease

You can check contents of APK like this:

        unzip -l ./build/android-native/app/build/outputs/apk/debug/app-debug.apk
