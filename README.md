# Norx
Norx is a Nim wrapper of the [ORX 2.5D game engine](http://orx-project.org/) library. ORX is written in C99, highly performant and cross platform.

The wrapper consists of two parts:

* The low level wrapper with basically one Nim module per ORX C header, almost 80 of them. All these are named o-xxx, like `oinput` or `oobject`.
* The high level wrapper with one Nim module per low level wrapper. Currently each high level wrapper also exports the low level wrapper.

The low level wrapper uses "C types" and is automatically generated as much as possible from the C header files.
The high level tries to use Nim style and Nim types as much as possible.

The only things you need to compile a Nim ORX game is this Nimble module and the ORX dynamic library files (`liborx[p|d].so|dll`) in a proper library path. However, for debugging etc it's more practical to also have the full ORX clone with ORX C sources etc.

# Build and install ORX
First install ORX dlls. At the moment best is to build them from a master git clone of ORX since it is in sync with the wrapper.

This works on my Ubuntu 64 bit (after installing normal C tools needed):

0. Clone ORX with `git clone https://github.com/orx/orx.git`.
1. Run `setup.sh` in top level first, this pulls down more dependencies.
2. Build with `cd code/build/linux/gmake && make config=release64` (build also `debug64` and `profile64` to get those extra libraries). Same on OSX but in `code/build/mac`. 
3. Copy libraries **to a library path** with for example `sudo cp -a $ORX/lib/dynamic/liborx* /usr/local/lib/` on Linux or OSX. May need to run `sudo ldconfig` after.

For other platforms, or if you get into trouble, follow [official ORX instructions](https://wiki.orx-project.org/en/guides/beginners/downloading_orx) that give much more details!

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
* Vectors are represented as Nim tuples right now. **We are still considering how to best handle these, and Colors too**.
* Some ORX structs use anonymous unions, this doesn't really work in Nim so... for example in Vector, which has 3 floats, I created in Nim different types depending on what kind of Vector it is. They are all tuple of three floats however, so should be compatible. Again, this may change.
* ORX builds three libraries. `liborx.so[dll|dylib]` is the release version of ORX. `liborxd.so[dll|dylib]` is the debug version. `liborxp.so[dll|dylib]` is the profile version. Norx will pick which one to dynamically load according to:
  * Pass `-d:release` to load the release version. This is the normal way to build a release binary with Nim.
  * Pass `-d:debug` to load the debug version. This is the normal way to build a debug binary with Nim.
  * Pass `-d:profile` to load the profile version.
* ...and well, I will add to this list as things come up.

# How to generate HTML docs
There is a bash script `generatedocs.sh` that will regenerate the contents of the `htmldocs` directory. The documentation is unfortunately not searchable when viewed through the local filesystem, but you can reach the current docs on:

* https://rawgit.com/gokr/norx/master/htmldocs/norx.html - The top level norx.nim doc. TODO: I need to add better comments!
* https://rawgit.com/gokr/norx/master/htmldocs/theindex.html - The index of all the docs.

I will investigate hosting docs on a proper website.

# How it was made
This wrapper was created through the following steps:

1. Run `convert.nim` in headers directory that uses `common.c2nim`.
2. Modifications to the original header files using `ifdefs`.
2b. Run Nim-C2NIM.st to do misc. transformations such as convert names and move comments.
3. Eventually "abandon all hope" and start editing the generated Nim files manually.

Unfortunately this means that at this moment (due to step 3 above), updates to ORX header files does not mean we can just regenerate this wrapper automagically.

# How to maintain
These are notes to "self". We track any changes to the `include` directory, for example if `orxObject.h` changes:

1. `cd headers`
2. `cp ../../../include/object/orxObject.h object/orxObject.h`
3. Using your IDE, reapply modifications that was overwritten :) - this should be handled better of course.
4. `c2nim common.c2nim object/orxObject.h` to reproduce `orxObject.nim`
5. Merge parts into `obj.nim` that should be there using `meld object/orxObject.nim ../src/norx/obj.nim`

# norx 0.5.0 - Upgrade to Orx b-release (1.12 release)
This was not done by the steps above but manually merging corresponding header changes directly into nim files.
1. Compare orx header changes, between versions 2020-07 and b-release branch.
2. Added build.nim contaiing value from orxBuild.h after running setup.sh in Orx from b-release branch.
3. Problematic orxColorList.h was referenced by macro in orxVector.h generating list of colors of the orxVECTOR 
   This is solved by running new script in scripts/crreateNimColors.sh that generates colors in src/norx/colorList.nim
4. Verifying all official samples works with Orx library compiled from b-release branch

