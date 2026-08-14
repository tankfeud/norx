# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.8.1] - 2026-08-15

### Added

- Added `orxSTATUS.isSuccess` and `orxSTATUS.isFailure` predicates. `STATUS_NONE` satisfies neither predicate, and statuses remain ORX enums rather than implicit booleans.
- Added value-oriented `orxVECTOR` arithmetic, size, distance, normalization, rotation, equality, dot, and cross operations, together with `+`, `-`, `*`, `/`, `+=`, `-=`, `*=`, and `/=` operators and a two-component `newVector(x, y)` constructor. Existing pointer-based operations remain available.
- Added the exported `objects` module with value overloads for object pivot, origin, size, position, world position, scale, world scale, and speed getters and setters.
- Added call-scoped Nim `string` overloads for input, configuration, resource, object, and sound APIs, including dynamic config section names, input names, text, FX, sounds, and resource paths.
- Added a complete Boulder Dash sample with authored and generated caves, digging, collectibles, pushable and falling tiles, scoring, a timer, sounds, licensed assets, and startup checks.
- Added regression coverage for boolean ABI and conversions, status predicates, vector operations, object value overloads, and dynamic Nim string arguments.

### Changed

- **Breaking:** Changed `orxBOOL` from an alias of `cuint` to a distinct C-sized type. Its ABI size and bidirectional Nim `bool` converters are preserved, but code that treated an `orxBOOL` as an arbitrary integer now requires an explicit conversion.
- Reworked Pong into a complete two-player sample with fixed-step collision handling, scoring, match wins, pause and restart controls, effects, sounds, readable UI, startup checks, and checkout-local ORX library discovery.
- Updated Pong and Boulder Dash to demonstrate direct Nim boolean and string arguments, value-based vector/object APIs, and explicit status handling.
- Expanded the README and tutorial with boolean, status, vector, object-overload, string-lifetime, and wrapper-architecture guidance.
- Added Boulder Dash to the `nimble samples` compilation checks.

### Fixed

- Corrected `newSpVector`, `newRgbVector`, `newHslVector`, and `newHsvVector` to initialize their actual named components instead of Cartesian vector fields.
- Corrected tutorial and official-sample calls to explicitly discard or inspect status values returned by setters and `enable`.
- Moved Pong status messages above the center of the court so they no longer obscure the ball.

[Unreleased]: https://github.com/tankfeud/norx/compare/0.8.1...HEAD
[0.8.1]: https://github.com/tankfeud/norx/compare/0.8.0...0.8.1
