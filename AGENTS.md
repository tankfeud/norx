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

## Releases

Norx releases use the package version as an annotated Git tag, for example `0.8.1`, and a matching GitHub release named `Norx 0.8.1`. Never move, replace, or force-push a published release tag; fix mistakes with a new release.

### 1. Review the Release Range

Start from a clean, synchronized default branch and fetch existing tags. Identify the previous release and inspect every commit and changed file in the range, not only the latest commit:

```bash
git status --short --branch
git fetch origin --tags
git log --oneline 0.8.0..HEAD
git diff --stat 0.8.0..HEAD
git diff 0.8.0..HEAD
```

Replace `0.8.0` with the actual previous tag. Confirm that the intended new tag and GitHub release do not already exist before continuing.

### 2. Update the Changelog Carefully

`CHANGELOG.md` follows Keep a Changelog. Preserve the empty `Unreleased` section and add a dated release section using the exact package version:

```markdown
## [Unreleased]

## [0.8.1] - YYYY-MM-DD
```

- Derive entries from both `git log` and the actual diff since the previous tag. Do not guess, omit notable commits, or paste commit subjects without explaining their user-facing effect.
- Organize entries under `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, or `Security` as applicable. Omit empty categories.
- Call out breaking source or ABI changes explicitly, including required migration steps or explicit conversions.
- Mention new public modules, helpers, overloads, supported Nim/ORX versions, sample applications, documentation, and regression coverage when relevant.
- Keep internal cleanup out of the changelog unless it changes generated output, behavior, compatibility, or contributor workflows.
- Update comparison links at the bottom: `Unreleased` compares the new version with `HEAD`, and the release compares the previous tag with the new tag.
- Re-read the completed section against every commit in the release range before committing it.

### 3. Bump Versions Consistently

Update `version` in `norx.nimble`. Search the repository for the old version and update other constraints only when semantically required. In particular, sample packages that use APIs introduced by the release must require the new Norx version.

Do not change the documented ORX version unless the submodule revision and generated wrapper actually changed. The changelog version, Nimble version, annotated tag, and GitHub release must all match exactly.

### 4. Run Release Verification

Run the full Verification section above. Also validate the root package and exercise complete runtime startup for the game samples:

```bash
nimble check
nim c samples/pong/pong.nim
./samples/pong/pong --startup-test true
nim c samples/boulderdash/boulderdash.nim
./samples/boulderdash/boulderdash --startup-test true
git diff --check
```

The ORX libraries must be available to both the linker and runtime as described in Setup. Run `./build.sh` when the ORX revision, wrapper generation, or annotations changed. Run `./build.sh --docs` and commit the generated documentation when a release changes the documented public API.

If a sample manifest is bumped to require the version being released, its remote `nimble check` can fail before the new tag exists. Before tagging, validate that sample against the local checkout with `nim check`, a direct `nim c`, and its startup test. Re-run remote dependency validation after the tag is published.

Do not release with failed checks, unreviewed generated changes, a dirty worktree, or a local branch that has diverged from its remote.

### 5. Commit, Tag, and Publish

Inspect `git status`, `git diff`, and recent history before creating the release commit. Stage only the reviewed release files, commit the version bump and changelog, then push the branch before creating the tag.

Create an annotated tag that points at the verified version commit:

```bash
git push origin master
git tag -a 0.8.1 -m "Norx 0.8.1"
git rev-parse "0.8.1^{}" HEAD
git push origin 0.8.1
gh release create 0.8.1 --verify-tag --latest --title "Norx 0.8.1" --notes-file /tmp/norx-release-notes.md
```

The two hashes printed by `git rev-parse` must match. Prepare `/tmp/norx-release-notes.md` from the matching changelog section before running `gh release create`. Release notes should include concise highlights, compatibility or breaking-change information, verification performed, and a full comparison link.

### 6. Validate the Published Release

After publication:

```bash
gh release view 0.8.1
git ls-remote --tags origin refs/tags/0.8.1 "refs/tags/0.8.1^{}"
git status --short --branch
```

Confirm that the release is public, non-draft, non-prerelease, marked latest when appropriate, and points to the expected commit. Confirm the branch is synchronized and the worktree is clean. Re-run sample manifest dependency checks once the new tag is available, and return the GitHub release URL.

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
