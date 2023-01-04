#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in
DIR=$(dirname "$SCRIPT")

# Replace cuchar with uint8 (cuchar is deprecated)
find $DIR/../src -name '*.nim' | xargs sed -i 's/cuchar/uint8/g'
