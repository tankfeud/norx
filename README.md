# Norx
[Norx](https://tankfeud.github.io/norx/index.html) is a **highly automated** Nim wrapper of the [ORX 2.5D game engine](http://orx-project.org/) library. ORX is written in C99, highly performant and cross platform. Norx makes it quite easy to make ORX based game in Nim.

The wrapper consists of two parts:

* The low level wrapper `wrapper.nim` created by Futhark from the ORX headers. It uses "C types" and is fully automatically generated from the C header files. This represents all the functionality in the ORX dynamic library.
* Higher-level files such as `basics.nim`, `vector.nim`, `objects.nim`, and the small subsystem modules are created by hand to use Nim style and Nim types and introduce useful overloads, templates, converters, and macros. These are kept up to date manually with new versions of ORX, but an annotation mechanism makes it easier to detect if changes need to be made.

The `norx.nim` module is the one you should import in your Nim code, it exports the other modules including the low level `wrapper.nim` for direct access to ORX functions and types.

The only things you need to compile a Nim ORX game is this Nimble module and the ORX dynamic library files (`liborx[p|d].so|dll`) in a proper library path. However, for debugging etc it's more practical to also have the full ORX clone with ORX C sources etc.

# Build ORX
First checkout the ORX submodule and build ORX as dynamic libraries (`liborx`, `liborxd` and `liborxp`).

## Initialize the ORX submodule
If this is a fresh clone, run:
```bash
git submodule update --init
```

## Build the libraries
This works on Ubuntu 64 bit (after installing normal C tools with `sudo apt-get install gcc g++ make`):

1. Run `./setup.sh` inside `orx/`. On a clean Ubuntu you will be asked to install some libraries: `sudo apt install libgl1-mesa-dev libsndfile1-dev libopenal-dev libxrandr-dev`. **Restart your shell (or logout/login) afterwards to get the `$ORX` variable set!**
2. Build all three ORX configurations:
   ```bash
   cd orx/code/build/linux/gmake
   make config=debug64
   make config=profile64   # optional, only needed for -d:profile builds
   make config=release64
   ```
   On macOS use `orx/code/build/mac` instead, and the corresponding build directory on Windows.

For other platforms, or if you get into trouble, follow the [official ORX instructions](https://wiki.orx-project.org/en/guides/beginners/downloading_orx) that give much more detail!

## No system install needed
Everything inside this repository — the tests and every sample — links **and runs** directly against `orx/code/lib/dynamic`. Each `config.nims` adds that directory to the linker search path and, on Linux and macOS, embeds an rpath so the resulting binaries also find the libraries at runtime. No `sudo cp` or `ldconfig` is required to work inside this repo.

If you develop applications *outside* this repository you have two choices:

1. Point your own `config.nims` at the repo libraries the same way this repo does (see below), or
2. Install the ORX libraries system-wide:
   ```bash
   sudo cp -a $ORX/lib/dynamic/liborx* /usr/local/lib/
   sudo ldconfig
   ```

NOTE for newer macOS versions: dylib files in `/usr/local/lib` are not searched by macOS when running a Norx app (system integrity protection sanitizes the environment). The rpath approach above sidesteps this; alternatively copy the dylibs next to your app executable. See <https://developer.apple.com/forums/thread/736719> and <https://briandfoy.github.io/macos-s-system-integrity-protection-sanitizes-your-environment/>.

# Install Nim
Easiest is to use Choosenim `curl https://nim-lang.org/choosenim/init.sh -sSf | sh` or see [Official download](https://nim-lang.org/install.html).

# Install Norx
Install the Norx wrapper by running  `nimble install` in this directory.

# Library Linking Configuration
Norx uses a build-time linking approach through `config.nims` files. Each Norx project (including samples) contains a `config.nims` file that adds the repository's local ORX library directory to the linker search path, embeds an rpath for runtime loading, and selects the appropriate ORX library version based on your build configuration:

```nim
import std/os

let rootDir = currentSourcePath().parentDir / "../.."
let orxLibraryDir = normalizedPath(rootDir / "orx/code/lib/dynamic")

switch("passL", "-L" & orxLibraryDir)

when defined(linux) or defined(macosx):
  switch("passL", "-Wl,-rpath," & orxLibraryDir)

when defined(release):
  switch("passL", "-lorx")      # Release version
elif defined(profile):
  switch("passL", "-lorxp")     # Profile version
else:
  switch("passL", "-lorxd")     # Debug version (default)
```

Adjust the `rootDir` relative path so that `orxLibraryDir` points at a directory containing the ORX dynamic libraries.

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
* `orxCHAR *` has been mapped to `cstring`. Common APIs also have `string` overloads that convert only for the duration of the ORX call, so dynamic Nim strings can be passed without warnings. A raw `cstring` pointer must not outlive the Nim string that backs it.
* If you get a `cstring` from ORX you can either keep it as such, but then beware that ORX decides when to deallocate it, or convert it to a Nim string using `$` but that will cause a copy of course. The positive is that you are then safe.
* `orxBOOL` is kept as a distinct C-sized type for ABI compatibility, with converters in both directions. Use normal Nim booleans in application code: `if isActive("Quit"):` and `object.enable(true)`.
* `orxSTATUS` remains an ORX enum because failure can represent control flow as well as an error. Use `status.isSuccess` and `status.isFailure` when a boolean predicate reads more naturally than comparing with `STATUS_SUCCESS` or `STATUS_FAILURE`.
* Generally all ORX things are `ptr orxBLABLA` and not wrapped by Norx. If you keep such around, remember that they may disappear on you when ORX deallocates!
* Passing procs as callbacks to ORX works fine, as long as they are marked with the Nim pragma `{.cdecl.}`, this can be seen in the examples where the update, run, exit, update procs are marked that way.
* The main game loop of ORX is actually in Nim, you can find it in `norx.nim` so you could quite easily make your own loop instead of creating callbacks and calling `execute`. See `sample2` which does that. Note that this style is NOT the recommended ORX style, since that loop varies depending on platform (Android has some special parts) and normally that loop is in the ORX codebase so if ORX evolves it may change how it is supposed to work.
* Vectors are represented as Nim tuples. The original pointer-based ORX operations remain available, while value overloads and arithmetic operators support expressions such as `position + velocity * deltaTime` and `direction.normalize`.
* Common object vector properties have value overloads under their original ORX names. Both `object.setPosition(addr position)` and the more idiomatic `object.setPosition(position)` remain valid.
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
   git checkout 1.17
   ./setup.sh
   ```
3. Build and install ORX libraries as described above in this file.
4. Run `build.sh` in the top-level directory to regenerate and validate the wrapper:
   ```
   ./build.sh
   ```
   Pass `--docs` to regenerate the API documentation as well.
5. The build should fail if some of the parts in ORX have been modified that we have manually "rewritten"
   in Nim style, like `vector.nim` for example. We use `annotation.nim` to detect via hash if specific parts of the ORX
   codebase has changed. Futhark captures everything in the library, but inline functions and C defines and macros are not
   captured this way and that is why we use `annotation.nim`. If the build fails you need to analyze and update Nim code
   and update the hashes.
