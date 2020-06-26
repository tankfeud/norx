# A trivial sample using Norx
This is just a trivial port of the original ORX sample with a spinning logo.

# Install sample1
First install ORX, Nim and Norx as described in top README.

Then run `nimble install` in this directory which will compile and install the binary in release mode.

After that you can run `sample1`. ESC quits. Pressing the key below ESC (may be different depending on your keyboard, on mine it's "§" but evidently "`" on others I guess) opens the ORX console.

# Compiling
A Nim debug build will use `liborxd.so`, a release build will use `liborx.so` and if you build with `nim c -d:profile` it will use `liborxp.so`.