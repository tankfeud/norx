# A trivial sample using ORX via Futhark
This is just a trivial port of the original ORX sample with a spinning logo.

# Install sample1
First install ORX & Nim as described in top README.

Then run `nimble install` in this directory which will compile and install the `sample1` binary in release mode, or run `nimble run` without installing the binary.

ESC quits. Pressing the key below ESC (may be different depending on your keyboard, on mine it's "§" but evidently "`" on others I guess) opens the ORX console.

# Compiling
TODO: Right now it always uses the release version of the ORX library, see cfg file.
A Nim debug build will use `liborxd.so|dylib|dll`, a release build will use `liborx.so|dylib|dll` and if you build with `nim c -d:profile` it will use `liborxp.so|dylib|dll`.