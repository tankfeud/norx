#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in
DIR=$(dirname "$SCRIPT")

# Run c2nim on header files
#cd $DIR/../headers
#nim c -r convert.nim

# Copy all nim files to src recursively
#echo "Copying nim files to src2"
#mkdir -p $DIR/../src2
#find $DIR/../headers -name '*.nim' | xargs cp -t $DIR/../src2


# Replace cuchar with uint8 (cuchar is deprecated)
#find $DIR/../src -name '*.nim' | xargs sed -i 's/cuchar/uint8/g'

# Execute Squeak tweaks to nim sources.
cd $DIR/..
rm -rf $DIR/../src/norxnew
mkdir -p $DIR/../src/norxnew
$DIR/squeak/squeak.sh -nosound $DIR/squeak/squeak.image $DIR/tweaks.st
exit 0
# Generate docs
TAG=`git describe --tags`
echo Generating documentation for commit/tag: $TAG
rm -rf $DIR/../htmldocs/*
nim doc --project --outdir:$DIR/../htmldocs --index:on --git.url:https://github.com/tankfeud/norx --git.commit:$TAG $DIR/../src/norx.nim
