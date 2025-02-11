# Norx
Norx is a Nim wrapper of the [ORX 2.5D game engine](http://orx-project.org/) library. ORX is written in C99, highly performant and cross platform.

The wrapper consists of two parts:

* The low level wrapper `wrapper.nim` created by Futhark from the ORX headers. It uses "C types" and is fully automatically generated from the C header files.
* The high level modules like `norx.nim` created by hand to use Nim style and Nim types and introduces useful Nim templates, converters and macros.

The `norx.nim` module is the one you should import in your Nim code, it also exports the low level `wrapper.nim` for direct access to ORX functions and types.

The only things you need to compile a Nim ORX game is this Nimble module and the ORX dynamic library files (`liborx[p|d].so|dll`) in a proper library path. However, for debugging etc it's more practical to also have the full ORX clone with ORX C sources etc.

# Build and install ORX
First build ORX as dynamic libraries (liborx, liborxd and liborxp).

This works on my Ubuntu 64 bit (after installing normal C tools needed, more specifically `sudo apt-get install gcc g++ make`):

1. After running `setup.sh` in `orx` directory, **restart shell (or logout/login) to get $ORX variable set!**. On a clean Ubuntu you will be asked to install some libraries: `sudo apt install libgl1-mesa-dev libsndfile1-dev libopenal-dev libxrandr-dev`
2. Build with `cd code/build/linux/gmake && make config=release64` (build also `debug64` and `profile64` to get those extra libraries). Same on OSX but in `code/build/mac`. 
3. Copy libraries **to a library path** with for example `sudo cp -a $ORX/lib/dynamic/liborx* /usr/local/lib/` on Linux or OSX. May need to run `sudo ldconfig` after.

For other platforms, or if you get into trouble, follow [official ORX instructions](https://wiki.orx-project.org/en/guides/beginners/downloading_orx) that give much more details!

NOTE for newer MacOS versions, dylib files in /usr/local/lib is not searched by macOS when running a Norx app. You can copy them to the local folder next to the app executable.
See also https://developer.apple.com/forums/thread/736719 and https://briandfoy.github.io/macos-s-system-integrity-protection-sanitizes-your-environment/)

# Install Nim
Easiest is to use Choosenim `curl https://nim-lang.org/choosenim/init.sh -sSf | sh` or see [Official download](https://nim-lang.org/install.html).

# Install Norx
Install the Norx wrapper by running  `nimble install` in this directory.

# Samples
See `samples` directory, `official_samples` directory (contributed by @jseb) or [norxsample](https://github.com/gokr/norxsample). The samples should run fine in at least Linux and OSX. The android-native sample can also be built for Android.

# Norx vs Orx
These are the "differences" that you should be aware of when you read ORX documentation/tutorials and apply it to Norx:

* Norx wrappers have been stripped of "module prefixes", so in ORX you have `orxObject_SetSpeed` but in Norx it's `setSpeed`, first character lower case.
* Some very common function names (that lots of modules share) have kept a module prefix, but in Nim style, since they would otherwise cause clashes, like `orxObject_CreateFromConfig` is in Norx `objectCreateFromConfig` and `orxObject_Create` is `objectCreate`. Same goes for `Setup`, `Init`, `Exit` and `Get` in basically all modules. Of those you normally would only use `Get` yourself.
* All memory allocation/deallocation of ORX things are done by ORX. If you stick to "normal" Nim code, all Nim memory is garbage collected by Nim.
* `orxCHAR *` has been mapped to `cstring` so you can pass Nim strings into all ORX functions just fine, since they are compatible with `cstring`. Remember that Nim strings are garbage collected by Nim so passing temporary strings into ORX can be dangerous if ORX keeps that pointer around. I haven't looked at ORX source to see if that is a common pattern, I suspect not.
* If you get a `cstring` from ORX you can either keep it as such, but then beware that ORX decides when to deallocate it, or convert it to a Nim string using `$` but that will cause a copy of course. The positive is that you are then safe.
* Generally all ORX things are `ptr orxBLABLA` and not wrapped by Norx. If you keep such around, remember that they may disappear on you when ORX deallocates!
* Passing procs as callbacks to ORX works fine, as long as they are marked with the Nim pragma `{.cdecl.}`, this can be seen in the examples where the update, run, exit, update procs are marked that way.
* The main game loop of ORX is actually in Nim, you can find it in `norx.nim` so you could quite easily make your own loop instead of creating callbacks and calling `execute`. See `sample2` which does that. Note that this style is NOT the recommended ORX style, since that loop varies depending on platform (Android has some special parts) and normally that loop is in the ORX codebase so if ORX evolves it may change how it is supposed to work.

TODO, how are these handled now with Futhark?
* Vectors are represented as Nim tuples right now. **We are still considering how to best handle these, and Colors too**.
* Some ORX structs use anonymous unions, this doesn't really work in Nim so... for example in Vector, which has 3 floats, I created in Nim different types depending on what kind of Vector it is. They are all tuple of three floats however, so should be compatible. Again, this may change.
* ORX builds three libraries. `liborx.so[dll|dylib]` is the release version of ORX. `liborxd.so[dll|dylib]` is the debug version. `liborxp.so[dll|dylib]` is the profile version. Norx will pick which one to dynamically load according to:
  * Pass `-d:release` to load the release version. This is the normal way to build a release binary with Nim.
  * Pass `-d:debug` to load the debug version. This is the normal way to build a debug binary with Nim.
  * Pass `-d:profile` to load the profile version.
* ...and well, I will add to this list as things come up.

# How to generate HTML docs
There is a bash script `build.sh` that will regenerate the wrapper and the contents of the `htmldocs` directory. The documentation is unfortunately not searchable when viewed through the local filesystem, but you can reach the current docs on:

* https://rawgit.com/tankfeud/norx/master/htmldocs/norx.html - The top level norx.nim doc. TODO: I need to add better comments!
* https://rawgit.com/tankfeud/norx/master/htmldocs/theindex.html - The index of all the docs.


# How it was made
This wrapper was created through the following steps:

1. If this is a fresh clone, run `git submodule update --init` to get the ORX submodule.
2. Checkout ORX submodule of specific new version and run `setup.sh` to get all dependencies and to generate `orxBuild.h`:
   ```
   cd orx
   git checkout 1.15
   ./setup.sh
   ```
3. Run `build.sh` in top level directory to regenerate the wrapper and generate the docs:
   ```
   ./build.sh
   ```


# norx 0.5.0 - Upgrade to Orx release 1.12
This was not done by the steps above but manually merging corresponding header changes directly into nim files.
1. Compare orx header changes, between versions 2020-07 and 1.12 tag.
2. Added build.nim containing value from orxBuild.h after running setup.sh in Orx from version at git tag 1.12.
3. Problematic orxColorList.h was referenced by macro in orxVector.h generating list of colors of the orxVECTOR 
   This is solved by running new script in scripts/crreateNimColors.sh that generates colors in src/norx/colorList.nim
4. Verifying all official samples works with Orx library compiled from 1.12 tag

