# Pong

A complete two-player Pong game implemented with Nim, Norx, and ORX 1.17.

The sample keeps gameplay in a small typed Nim model and uses Norx for the engine-facing pieces: input, clock callbacks, object creation, text, and data-driven visual effects. Paddle movement and time-of-impact ball collisions share a fixed-step simulation, so gameplay remains stable when rendering frame times vary.

Its engine boundary demonstrates direct Nim booleans and strings, explicit ORX status predicates, and value-based object positioning while retaining the original ORX API names.

## Controls

- **W / S** - Move the left paddle
- **Up / Down** - Move the right paddle
- **Space** - Pause or resume the current rally
- **R** - Restart the match
- **Escape** - Quit

The first player to seven points wins.

## Building

Norx requires Nim 2.2.4 or newer and the matching ORX 1.17 dynamic library. From this directory:

```bash
nimble build
./pong
```

Use `--startup-test` to initialize the complete scene, validate its input and effect configuration, run the gameplay model checks, and exit automatically after a few frames:

```bash
./pong --startup-test true
```

## Structure

- `pong.nim` contains the game model, collision rules, ORX callbacks, and a small startup test.
- `data/config/pong.ini` defines the viewport, controls, court, graphics, text, and hit effects.

## Assets

Sound effects are from Kenney and released under Creative Commons CC0 1.0. Source links and the original license files are included in [`data/ASSETS.md`](data/ASSETS.md).
