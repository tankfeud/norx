# Some trivial samples using ORX via Futhark
First install ORX & Nim as described in top README.

Then run `nimble install` in each directory which will compile and install the sample binariies in release mode, or just run `nimble run` without installing the binary.

ESC quits. Pressing the key below ESC (may be different depending on your keyboard, on mine it's "§" but evidently "`" on others I guess) opens the ORX console.

# Compiling
A Nim debug build `nim c -d:debug xxx.nim` will use `liborxd.so|dylib|dll`, a release build `nim c -d:release xxx.nim` will use `liborx.so|dylib|dll` and if you build with `nim c -d:profile xxx.nim ` it will use `liborxp.so|dylib|dll`.
