# CLAUDE.md

## Project Overview

Norx is a Nim wrapper for the ORX 2.5D game engine library. ORX is a C99 game engine that is highly performant and cross-platform. The wrapper provides both low-level C bindings and high-level Nim abstractions.

## Architecture

The wrapper consists of two main parts:

1. **Low-level wrapper (`src/wrapper.nim`)**: Automatically generated from ORX C headers using Futhark. Uses C types and provides direct access to ORX functions. Generated low-level bindings (do NOT edit directly!)

2. **High-level modules**: Hand-written Nim modules that provide idiomatic Nim APIs, including:
   - `src/norx.nim` - Main high-level wrapper module that also exports `src/wrapper.nim` (import this)
   - `src/basics.nim` - Various fundamental bits and pieces
   - `src/vector.nim` - Vector operations, based on inline functions from ORX
   - `src/display.nim` - Color related functions
   - `src/joystick.nim` - Joystick input handling
   - `src/annotation.nim` - A Nim meta mechanism which we use to keep the Norx wrapper in sync with underlying ORX sources 


## Key Components

- **ORX Submodule**: Contains the actual ORX C library sources in the `orx/` directory
- **Wrapper Generation**: Uses Futhark (https://github.com/PMunch/futhark) to automatically generate Nim bindings from C headers
- **Samples**: Multiple sample projects demonstrating usage in `samples/` and `official_samples/`
- **Build System**: Uses Nimble for package management and a custom `build.sh` script

## Build Commands

### Building the Wrapper
```bash
./build.sh              # Regenerate wrapper from ORX sources
./build.sh --docs        # Also generate HTML documentation
```

### Installing
```bash
nimble install           # Install the Norx package locally
```

### Running Samples
```bash
cd samples/sample1
nimble run
```

### Testing
```bash
cd tests
nim c -r testObject.nim
```

## Development Workflow

1. **Wrapper Generation**: The `src/wrapper.nim` file is automatically generated using `scripts/create_wrapper.nim` which processes ORX C headers with Futhark.

2. **Function Naming**: ORX functions are renamed to remove module prefixes (e.g., `orxObject_SetSpeed` becomes `setSpeed`). Some common functions keep prefixes to avoid naming collisions.

3. **Build Process**: 
   - `build.sh` first installs dependencies for the wrapper generation script
   - Generates `wrapper.nim` using Futhark
   - Validates the wrapper by compiling `norx.nim`
   - Optionally generates HTML documentation

4. **Version Compatibility**: The build system checks that the runtime ORX library version matches the compile-time version to prevent incompatibilities.

## Key Files for Development

- `scripts/create_wrapper.nim` - Script that generates the wrapper using Futhark
- `build.sh` - Main build script for regenerating wrapper and docs
- `norx.nimble` - Package configuration
- `orx/` - ORX C library submodule


## Important Notes

- Always import `norx` module, not `wrapper` directly
- ORX handles memory management for ORX objects
- Nim strings are compatible with ORX's `cstring` parameters
- Callback functions must use `{.cdecl.}` pragma
- The main game loop is implemented in Nim (in `norx.nim`)

## Coding Guidelines
- Do not shadow the local `result` variable (Nim built-in)
- Doc comments: `##` below proc signature
- Prefer generics or object variants over methods
- Use `return expression` for early exits
- Prefer direct field access over getters/setters
- JSON: Use `%*{}` syntax
- **NO `asyncdispatch`** - use `taskpools` for concurrency
- Remove old code during refactoring
- Import full modules, not select symbols
- Use `*` to export fields that should be publicly accessible
- If something is not exported, export it instead of doing workarounds
- Do not be afraid to break backwards compatibility
- Do not add comments talking about how good something is, it is just noise. Be brief.
- Do not add comments that reflect what has changed, we use git for change tracking, only describe current code
- Do not add unnecessary commentary or explain code that is self-explanatory
- **Single-line functions**: Use direct expression without `result =` assignment or `return` statement
- **Multi-line functions**: Use `result =` assignment and `return` statement for clarity
- **Early exits**: Use `return value` instead of `result = value; return`

## Development Best Practices
- Always end todolists by running all the tests at the end to verify everything compiles and works

### Refactoring and Code Cleanup
- **Remove old unused code during refactoring** - We prioritize clean, maintainable code over backwards compatibility
- When implementing new architecture patterns, completely remove the old implementation patterns
- Delete deprecated methods, unused types, and obsolete code paths immediately
- Keep the codebase lean and focused on the current architectural approach