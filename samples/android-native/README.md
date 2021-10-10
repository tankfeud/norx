# Norxdemo
A template project for Android. Made for development **on Linux**. May work fine on OSX also, not yet tested.

# Nim, ORX and Norx
First follow instructions at [Norx wrapper](https://github.com/tankfeud/norx) to get ORX, Nim and Norx installed.

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

Create keystore:
   ./makekeystore.sh

DO NOT FORGET: Copy ./build/android-native/key.properties.sample to ./build/android-native/key.properties end edit with whatever passwords you used!

First make sure you have ORX cloned. (currently we are in synk with ORX v1.12 (branch b-release)
You can [follow instructions at the ORX wiki](https://wiki.orx-project.org/getting_android_tools_and_orx) or simply do the following:

Then make sure you have Android SDKs installed, typically done via Android Studio and
ANDROID_HOME set to point to your Sdk, like for example:

        export ANDROID_HOME=/home/gokr/Android/Sdk

You also want PATH set to these, note the numbers may be different:

        export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/build-tools/31.0.0:$ANDROID_HOME/ndk/23.0.7599858:$PATH

First make sure you have `ORX` env var set to the `code` directory of your ORX git clone. (done by the ORX setup.sh)

Then go back to norxdemo and build (generate C code and produce debug and release APKs) using:

        ./build-android.sh

That compiles libraries for all binary Android platforms, but we currently only use arm32 & arm64.
See end of script how to build a release APK instead.
Use "gradle build" to make debug and release APKs for both arm32 & arm64.

The build-android.sh script will:

* Mirror the data directory into the build/android-native/app/src/main/assets directory.
* Generate and copy C sources from Nim into build/android-native/app/src/main/jni/arm(32|64)
* Go into android-native and call "assembleDebug -Parmeabi-v7a" to make debug APK for arm32

Note that `gradle build` will in turn call `ndk-build` in the jni directory and this produces `libnorxdemo.so` (statically linked with liborx). Then gradle will pack it all into an APK with `MainActivity.java` etc. 
For debugging purposes it's often useful to go into the jni directory and run `ndk-build clean` followed by `ndk-build V=1` (verbose) to see the actual compilation and linking commands used.

You can then afterwards from `build/android-native` do:

        gradle installDebug
        gradle uninstallDebug
        gradle installRelease
        gradle uninstallRelease

And all other tasks gradle offers, list them with:

        gradle tasks

You can check contents of resulting APK like this:

        unzip -l ./build/android-native/app/build/outputs/apk/debug/app-debug.apk


# Gotchas
Making this work I stumbled on several things, too many to recall. Here is a list:

* It took me forever to realize I needed dynlibOverride with the Nim compiler so that we do not try to load liborx.so (with Android we do static linking with orx)
* The CPU architecture for C code produced by Nim needs to match the target CPU for gradle/ndk-build.
* You can not use `./` in paths in ORX ini files to refer to sub directories
