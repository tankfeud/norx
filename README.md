# Norx
Norx is a Nim wrapper of the [ORX game engine](http://orx-project.org/) library. ORX is written in C99 and highly performant and cross platform.
The wrapper basically consists of one Nim module per ORX C header, almost 80 of them.

The only things you need to compile a Nim ORX game is this Nimble module and the ORX dynamic library files (`liborx[p|d].so|dll`) in a proper library path.

However, for debugging etc it's more practical to also have the full ORX clone with ORX C sources etc.

# Build and install ORX
First install ORX dlls. At the moment best is to build them from a master git clone of ORX since it is in sync with the wrapper.

This works on my Ubuntu 64 bit (after installing normal C tools needed):

0. Clone ORX with `git clone https://github.com/orx/orx.git`.
1. Run `setup.sh` in top level first, this pulls down more dependencies.
2. Build with `cd code/build/linux/gmake && make config=release64` (build also `debug64` and `profile64` to get those extra libraries)
3. Copy libraries **to a library path** with for example `cp -a ../../../bin/liborx*.so /usr/lib/` 

For other platforms, or if you get into trouble, follow [official ORX instructions](https://wiki.orx-project.org/en/guides/beginners/downloading_orx) that give much more details!

# Install Nim
Easiest is to use Choosenim `curl https://nim-lang.org/choosenim/init.sh -sSf | sh` or see [Official download](https://nim-lang.org/install.html).

# Install Norx
Install the Norx wrapper by running  `nimble install` in this directory.

See `samples` directory for some samples using it!


# How it was made
This wrapper was created through the following steps:

1. Run `convert.nim` in this directory that uses `common.c2nim`.
2. Modifications to the original header files using `ifdefs`.
3. Eventually "abandon all hope" and start editing the generated Nim files manually.

Unfortunately this means that at this moment (due to step 3 above), updates to ORX header files does not mean we can just regenerate this wrapper automagically.

# How to maintain
These are notes to "self". We track any changes to the `include` directory, for example if `orxObject.h` changes:

1. `cd headers`
2. `cp ../../../include/object/orxObject.h object/orxObject.h`
3. Using your IDE, reapply modifications that was overwritten :) - this should be handled better of course.
4. `c2nim common.c2nim object/orxObject.h` to reproduce `orxObject.nim`
5. Merge parts into `obj.nim` that should be there using `meld object/orxObject.nim ../src/norx/obj.nim`