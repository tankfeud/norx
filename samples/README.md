# Samples

Standalone Nim programs exercising the Norx API, each in its own directory.
Build and run a sample from its own directory — every `config.nims` links
against the repository-local ORX libraries, so no system install is needed
(see the top-level README for how to build ORX once).

## Games

- `pong/` — a complete two-player Pong game. W/S vs arrow keys, fixed-step
  collision handling, scoring to seven, sounds, pause and restart, plus a
  `--startup-test true` self-test that validates the scene and game rules.
- `boulderdash/` — a complete Boulder Dash-style grid game. Dig through dirt,
  collect diamonds, dodge falling boulders and reach the exit before time
  runs out, with random cave generation and CC0 Kenney art and sounds.

## Minimal examples

- `ball/` — the smallest possible Norx program (the one shown on the
  [website](https://tankfeud.github.io/norx/)). One object, one input, one
  update callback. ORX loads `ball.ini` automatically from the directory.
- `sample1/` — the standard ORX pattern: `bootstrap` + `init`/`run`/`exit`
  callbacks and a rotating logo with fade-in FX. The recommended starting
  structure.
- `sample2/` — the same trivial scene, but replacing ORX's `execute` loop
  with a hand-rolled main loop in Nim. Deliberately *not* the recommended
  ORX style; use it to understand what `execute` does for you.

## Utilities

- `qr-code/` — renders a QR code on screen using the `qrcode` Nim package,
  demonstrating creating many small objects at runtime from configuration.

## Official tutorial ports

- `official/` — Nim ports of the official ORX C tutorials (objects, clocks,
  viewports, animation, physics, sound, FX, scrolling, locale, spawners,
  lighting), contributed by @jseb.

## Notes

- ESC quits in most samples. The key below ESC (`` ` `` on many keyboards)
  opens the ORX console for live inspection.
- A debug build uses `liborxd`, a release build `-d:release` uses `liborx`,
  and `-d:profile` uses `liborxp` — selected automatically by `config.nims`.
- The `android-native/` sample needs the Android SDK/NDK and has its own
  README.
