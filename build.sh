#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in
DIR=$(dirname "$SCRIPT")

# Recreate wrapper.nim using Futhark from ORX sources
rm ./src/wrapper.nim
nim c -r --maxLoopIterationsVM:100000000 -d:futharkRebuild ./scripts/create_wrapper.nim

# If we now have wrapper.nim, generate docs
if [ -f ./src/wrapper.nim ]; then
  TAG=`git describe --tags`
  echo Generating documentation for commit/tag: $TAG
  rm -rf $DIR/htmldocs/*
  nim doc --project --outdir:$DIR/htmldocs --index:on --git.url:https://github.com/tankfeud/norx --git.commit:$TAG $DIR/src/norx.nim
else
  echo "FAILED: No wrapper.nim found, skipping documentation generation"
fi
