#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, and pipeline failures
# Parse command line arguments
gendocs=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo "Build the norx wrapper and optionally generate documentation"
            echo ""
            echo "Options:"
            echo "  --docs       Generate documentation"
            echo "  --help, -h   Show this help message"
            exit 0
            ;;
        --docs)
            gendocs=true
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
    shift
done

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in
DIR=$(dirname "$SCRIPT")

# Make sure dependencies are installed for create_wrapper.nim
if ! (cd scripts && nimble install -d); then
    echo "ERROR: Failed to install dependencies" >&2
    exit 1
fi

# Recreate wrapper.nim using Futhark from ORX sources
rm -f ./src/wrapper.nim ./scripts/create_wrapper # -f prevents errors if file doesn't exist
if ! nim c -r --maxLoopIterationsVM:100000000 -d:futharkRebuild ./scripts/create_wrapper.nim; then
    echo "ERROR: Failed to generate wrapper.nim" >&2
    exit 1
fi
rm -f ./scripts/create_wrapper

# Check that wrapper is up to date with ORX sources by compiling norx.nim
# and processing annotations. errorOnAnnotationChange is used to fail the build
# if the wrapper is out of date with ORX sources.
echo "Checking that wrapper is up to date with ORX sources by compiling norx.nim"
if ! nim c -d:processAnnotations -d:errorOnAnnotationChange src/norx.nim; then
    echo "ERROR: Compilation of norx.nim failed, wrapper possibly out of date with ORX sources?" >&2
    exit 1
fi

if $gendocs; then
    # Generate documentation if wrapper.nim exists
    if [ -f ./src/wrapper.nim ]; then
        TAG=$(git describe --tags) || {
            echo "ERROR: Failed to get git tag" >&2
            exit 1
        }
        echo "Generating documentation for commit/tag: $TAG"
        
        rm -rf "$DIR/htmldocs/"* # Quote directory path
        if ! nim doc --project \
            --outdir:"$DIR/htmldocs" \
            --index:on \
            --git.url:https://github.com/tankfeud/norx \
            --git.commit:"$TAG" \
            "$DIR/src/norx.nim"; then
            echo "ERROR: Documentation generation failed" >&2
            exit 1
        fi
    else
        echo "ERROR: No wrapper.nim found, skipping documentation generation" >&2
        exit 1
    fi
fi
