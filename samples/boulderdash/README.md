# Boulder Dash

A small Boulder Dash-style game implemented with Norx and ORX 1.17.

The code demonstrates direct Nim booleans and strings, explicit ORX status predicates, and value-based vector properties while retaining the original ORX API names.

## Gameplay

Dig through the mine, collect every cyan diamond, and then reach the green exit before time runs out. Removing dirt can cause unsupported boulders and diamonds to fall, and either one can crush the player once it is moving. The player supports a resting loose tile while standing directly underneath it, so stepping sideways releases it to fall behind. Boulders and diamonds roll off each other when an adjacent side and the diagonal cell below it are empty.

### Controls

- **WASD or arrow keys** - Move and push boulders horizontally
- **N** - Generate a new random cave
- **R** - Restart the current authored or generated cave
- **Escape** - Quit

### Game Elements

- **Miner** - Player
- **Brown ground tiles** - Dirt that can be dug through
- **Brick tiles** - Fixed walls
- **Metal blocks** - Pushable boulders affected by gravity
- **Blue gem tiles** - Collectibles worth 10 points each and affected by gravity
- **Green crate** - Exit, usable after every diamond is collected

## Building

Norx requires Nim 2.2.4 or newer and the ORX 1.17 dynamic libraries built under `orx/code/lib/dynamic`. The sample's `config.nims` adds that directory to the link path and runtime rpath automatically.

Install the current Norx checkout and build the sample:

```bash
cd ../..
nimble install
cd samples/boulderdash
nimble build
./boulderdash
```

Use `--startup-test` to initialize the complete game and exit automatically after a few frames:

```bash
./boulderdash --startup-test true
```

## Level Design

The level is a 20 by 15 grid in `data/config/boulderdash.ini`. Every row must contain exactly 20 characters.

- `#` = Wall
- `.` = Dirt
- `O` = Boulder
- `D` = Diamond
- `E` = Exit
- `@` = Player start
- Space = Empty

Pressing **N** generates a new cave with connected diggable terrain, solid borders, a safe starting area, six diamonds, ten boulders, and one exit. Restarting preserves the generated layout.

## Assets

Graphics and sounds are from Kenney and released under Creative Commons CC0 1.0. Source links and the original license files are included in [`data/ASSETS.md`](data/ASSETS.md).
