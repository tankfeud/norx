# Norx
[Norx](https://tankfeud.github.io/norx/index.html) is a **highly automated** Nim wrapper of the [ORX 2.5D game engine](http://orx-project.org/) library. ORX is written in C99, highly performant and cross platform. Norx makes it quite easy to make ORX based game in Nim.

The wrapper consists of two parts:

* The low level wrapper `wrapper.nim` created by Futhark from the ORX headers. It uses "C types" and is fully automatically generated from the C header files. This represents all the functionality in the ORX dynamic library.
* The higher level files like `norx.nim`, `basics.nim`, `vector.nim` created by hand to use Nim style and Nim types and introduces useful Nim templates, converters and macros. These are kept up to date manually with new versions of ORX, but an annotation mechanism makes it easier to detect if changes needs to be made.

The `norx.nim` module is the one you should import in your Nim code, it exports the other modules including the low level `wrapper.nim` for direct access to ORX functions and types.

The only things you need to compile a Nim ORX game is this Nimble module and the ORX dynamic library files (`liborx[p|d].so|dll`) in a proper library path. However, for debugging etc it's more practical to also have the full ORX clone with ORX C sources etc.

# Build and install ORX
First checkout the ORX submodule and build ORX as dynamic libraries (liborx, liborxd and liborxp).

## Initialize the ORX submodule
If this is a fresh clone, run:
```bash
git submodule update --init
```

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

# Library Linking Configuration
Norx uses a build-time linking approach through `config.nims` files. Each Norx project (including samples) contains a `config.nims` file that automatically selects the appropriate ORX library version based on your build configuration:

```nim
when defined(release):
  switch("passL", "-lorx")      # Release version
elif defined(profile):
  switch("passL", "-lorxp")     # Profile version  
else:
  switch("passL", "-lorxd")     # Debug version (default)
```

## Library Selection
* **Debug builds** (default): Links to `liborxd` - includes debug symbols and assertions
* **Release builds** (`-d:release`): Links to `liborx` - optimized for performance
* **Profile builds** (`-d:profile`): Links to `liborxp` - optimized with profiling support

## Platform Compatibility
The system linker automatically handles platform-specific library extensions:
* **Linux**: `liborx.so`, `liborxd.so`, `liborxp.so`
* **macOS**: `liborx.dylib`, `liborxd.dylib`, `liborxp.dylib`
* **Windows**: `liborx.dll`, `liborxd.dll`, `liborxp.dll`

# Samples
See `samples` directory, `official_samples` directory (contributed by @jseb) or [norxsample](https://github.com/gokr/norxsample). The samples should run fine in at least Linux and OSX. The android-native sample can also be built for Android.

# Norx vs Orx
These are the "differences" that you should be aware of when you read ORX documentation/tutorials and apply it to Norx:

* Norx wrappers have been stripped of "module prefixes", so in ORX you have `orxObject_SetSpeed` but in Norx it's `setSpeed`, first character lower case.
* Some very common function names (that lots of modules share) have kept a module prefix, but in Nim style, since they would otherwise cause clashes, like `orxObject_CreateFromConfig` is in Norx `objectCreateFromConfig` and `orxObject_Create` is `objectCreate`. Same goes for `Setup`, `Init`, `Exit` and `Get` in basically all modules. You can see the list of **protectedNames** in `create_wrapper.nim`.
* All memory allocation/deallocation of ORX things are done by ORX. If you stick to "normal" Nim code, all Nim memory is garbage collected by Nim.
* `orxCHAR *` has been mapped to `cstring` so you can pass Nim strings into all ORX functions just fine, since they are compatible with `cstring`. Remember that Nim strings are garbage collected by Nim so passing temporary strings into ORX can be dangerous if ORX keeps that pointer around. I haven't looked at ORX source to see if that is a common pattern, I suspect not.
* If you get a `cstring` from ORX you can either keep it as such, but then beware that ORX decides when to deallocate it, or convert it to a Nim string using `$` but that will cause a copy of course. The positive is that you are then safe.
* Generally all ORX things are `ptr orxBLABLA` and not wrapped by Norx. If you keep such around, remember that they may disappear on you when ORX deallocates!
* Passing procs as callbacks to ORX works fine, as long as they are marked with the Nim pragma `{.cdecl.}`, this can be seen in the examples where the update, run, exit, update procs are marked that way.
* The main game loop of ORX is actually in Nim, you can find it in `norx.nim` so you could quite easily make your own loop instead of creating callbacks and calling `execute`. See `sample2` which does that. Note that this style is NOT the recommended ORX style, since that loop varies depending on platform (Android has some special parts) and normally that loop is in the ORX codebase so if ORX evolves it may change how it is supposed to work.
* Vectors are represented as Nim tuples right now. This makes them easier to work with in Nim.
* ORX builds three different library versions (release, debug, profile). Norx automatically selects the appropriate version based on your build configuration through `config.nims` files. See the "Library Linking Configuration" section above for details.
* ...and well, I will add to this list as things come up.

# How to generate HTML docs
There is a bash script `build.sh` that will regenerate the wrapper and the contents of the `docs` directory.

The documentation is unfortunately not searchable when viewed through the local filesystem, but you can reach the current docs via GitHub Pages:

* https://tankfeud.github.io/norx/index/norx.html - The top level norx.nim doc. TODO: I need to add better comments!
* https://tankfeud.github.io/norx/index/theindex.html - The index of all the docs.

To enable GitHub Pages: Go to repository Settings → Pages → Source: Deploy from branch → Branch: master, Folder: /docs


# How it was made
This wrapper is kept up to date through the following steps:

1. If this is a fresh clone, run `git submodule update --init` to get the ORX submodule.
2. Checkout ORX submodule of specific new version and run `setup.sh` to get all dependencies and to generate `orxBuild.h`:
   ```
   cd orx
   git fetch
   git checkout 1.16
   ./setup.sh
   ```
3. Build and install ORX libraries as described above in this file.
4. Run `build.sh` in top level directory to regenerate the wrapper and generate the docs:
   ```
   ./build.sh
   ```
5. The build should fail if some of the parts in ORX has been modified that we have manually "rewritten"
   in Nim style, like `vector.nim` for example. We us `annotations.nim` to detect via hash if specific parts of the ORX
   codebase has changed. Futhark captures everything in the library, but inline functions and C defines and macros are not
   captured this way and that is why we use `annotations.nim`. If the build fails you need to analyze and update Nim code
   and update the hashes.

