# Norxdemo
A template project for Android. Made for development **on Linux**. May work fine on OSX also, not yet tested.

# Nim, ORX and Norx
First follow instructions at [Norx wrapper](https://github.com/gokr/norx) to get ORX, Nim and Norx installed.

# Build and run
This is not the main target of this demo, but the easiest way to just build and run this trivial sample **locally on Linux/OSX** is to:

        nimble run

Or to only build a release binary:

        nimble build

More manually to make a release binary:

        cd src
        nim c -d:release -o:../norxdemo norxdemo.nim

...or a debug build:

        cd src
        nim c -o:../norxdemod norxdemo.nim

All these variants put the resulting executable in the top level so that it can use the assets under the `data` directory.

The reason to use `norxdemo` for a release build, `norxdemod` for a debug build and `norxdemop` for a profile build is because the executable name affects
how ORX picks ini-files from the `data/config` directory and it also affects which `liborx.so|.dylib|.dll` it will load when it runs.

# Android
Currently we build for Android by using an Android NDK project structure originally copied from the **android-native** demo in ORX, and modified a bit. There are two ways to make Android apps with ORX, I have so far picked the "native" variant, more can be read about this on the [ORX wiki](https://wiki.orx-project.org/en/tutorials/which_android).

You can [follow instructions at the ORX wiki](https://wiki.orx-project.org/getting_android_tools_and_orx) or simply do the following:

1. First make sure you have `ORX` env var set to the `code` directory of your ORX git clone.
2. Then make sure you have Android SDKs installed, typically done via Android Studio and `ANDROID_HOME` set to point to your Sdk, like for example:

        ANDROID_HOME=/home/gokr/Android/Sdk/

You also want PATH set to these sub directories (to have `adb` etc):

        /home/gokr/Android/Sdk/platform-tools:/home/gokr/Android/Sdk/tools/bin:/home/gokr/Android/Sdk/build-tools/28.0.0

3. Then build static ORX libraries for android-native:

        cd $ORX/build/android-native
        ndk-build clean
        ndk-build
        ./install.sh

That compiles libraries for all binary Android platforms. You shuld be able to verify them afterwards using `find $ORX/lib/static/android-native -name *.a`:

        gokr@maz:~/orx/norx$ find $ORX/lib/static/android-native -name *.a
        /home/gokr/orx/orx/code/lib/static/android-native/x86/liborx.a
        /home/gokr/orx/orx/code/lib/static/android-native/x86/liborxd.a
        /home/gokr/orx/orx/code/lib/static/android-native/x86/liborxp.a
        /home/gokr/orx/orx/code/lib/static/android-native/x86_64/liborx.a
        /home/gokr/orx/orx/code/lib/static/android-native/x86_64/liborxd.a
        /home/gokr/orx/orx/code/lib/static/android-native/x86_64/liborxp.a
        /home/gokr/orx/orx/code/lib/static/android-native/arm64-v8a/liborx.a
        /home/gokr/orx/orx/code/lib/static/android-native/arm64-v8a/liborxd.a
        /home/gokr/orx/orx/code/lib/static/android-native/arm64-v8a/liborxp.a
        /home/gokr/orx/orx/code/lib/static/android-native/armeabi-v7a/liborx.a
        /home/gokr/orx/orx/code/lib/static/android-native/armeabi-v7a/liborxd.a
        /home/gokr/orx/orx/code/lib/static/android-native/armeabi-v7a/liborxp.a

4. Then go back to norxdemo and build (generate C code and produce debug and release APKs) using:

        ./build-android.sh

This will:

* Mirror the data directory into the build/android-native/app/src/main/assets directory.
* Generate and copy C sources from Nim into build/android-native/app/src/main/jni
* Change directory into build/android-native and call "gradle build" to make debug and release APKs

Note that `gradle build` will in turn call `ndk-build` in the jni directory and this produces `libnorxdemo.so` (statically linked with liborx). Then gradle will pack it all into an APK with `MainActivity.java` etc. For debugging purposes it's often useful to go into the jni directory and run `ndk-build clean` followed by `ndk-build V=1` (verbose) to see the actual compilation and linking commands used.

You can then afterwards from `build/android-native` do:

        gradle installDebug
        gradle uninstallDebug
        gradle installRelease
        gradle uninstallRelease

And all other tasks gradle offers, list them with:

        gradle tasks

You can check contents of resulting APK like this:

        unzip -l ./build/android-native/app/build/outputs/apk/debug/app-debug.apk
