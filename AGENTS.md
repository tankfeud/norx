# AGENTS.md

## Project

Norx is a Nim wrapper for the ORX 2.5D game engine. The repository targets ORX 1.17 through the `orx/` Git submodule and requires Nim 2.2.4 or newer.

- ORX website: https://orx-project.org/
- ORX documentation: https://orx-project.org/wiki/

## Architecture

- `src/wrapper.nim` contains low-level C bindings generated from ORX headers by Futhark. Never edit it manually.
- `src/norx.nim` is the public entry point. Applications should import `norx`, not `wrapper`.
- `src/basics.nim`, `src/vector.nim`, `src/objects.nim`, and the small subsystem modules provide hand-written Nim APIs for C macros, inline functions, and higher-level conveniences.
- `src/annotation.nim` checks hand-written translations against selected sections of the ORX headers.
- `scripts/create_wrapper.nim` configures Futhark naming and post-processes generated bindings.
- `samples/` and `official_samples/` exercise the public API.

ORX owns ORX objects and their memory. Nim strings can be passed to `cstring` parameters, but a pointer must not outlive the Nim string that backs it. C callbacks must use `{.cdecl.}`.

## Setup

Initialize the submodule in a fresh clone:

```bash
git submodule update --init
```

Prepare and build ORX before running linked tests or samples:

```bash
cd orx
./setup.sh
cd code/build/linux/gmake
make config=debug64
make config=profile64
make config=release64
```

Use the corresponding platform build directory on macOS or Windows. Make the resulting ORX dynamic libraries available to the system linker and runtime loader.

## Wrapper Generation

Run the repository build script after changing the ORX revision or wrapper-generation logic:

```bash
./build.sh
```

This installs generator dependencies, recreates `src/wrapper.nim`, compiles `src/norx.nim`, and fails if any annotated ORX source section changed. Generate API documentation separately with:

```bash
./build.sh --docs
```

When an annotation changes:

1. Compare the referenced ORX C section with its Nim implementation.
2. Update the Nim implementation for semantic changes.
3. Refresh reviewed hashes with `nim c -d:processAnnotations -d:updateAnnotations src/norx.nim`.
4. Run `./build.sh` again; do not bypass `-d:errorOnAnnotationChange`.

## Verification

Check every test and sample at the end of a change:

```bash
nim check tests/test_basics.nim
nim check tests/test_vector.nim
nim check tests/test_strings.nim
nim check tests/test_enum.nim
nim c -r tests/testObject.nim
nimble samples
nim check samples/sample1/sample1.nim
nim check samples/sample2/sample2.nim
nim check samples/pong/pong.nim
nim check samples/boulderdash/boulderdash.nim
nim check samples/qr-code/show_qr.nim
```

Android requires its own SDK/NDK toolchain and should be verified separately when Android-specific code changes.

## Coding Style

- Use Nim 2.x syntax and import full modules rather than selected symbols.
- Export public APIs with `*`; prefer exposing the intended API over adding access workarounds.
- Do not shadow Nim's implicit `result` variable.
- Put `##` documentation comments immediately below proc signatures.
- Use direct expressions for single-line functions.
- In multi-line functions, use `result =` for the normal result and `return value` for early exits.
- Prefer direct field access, generics, or object variants over methods and unnecessary wrappers.
- Do not use `asyncdispatch`; use `taskpools` if concurrency is needed.
- Keep comments brief and explain current non-obvious behavior, not change history.
- Remove obsolete code during refactoring; backward compatibility is not a project requirement.
- Keep generated files reproducible and include regenerated output when source headers or generation logic changes.
