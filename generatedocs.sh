# Generate HTML docs
CHECK=`nim --version | grep "Version 1.3."`
if [ -z "$CHECK" ]
then
  echo "Need at least Nim version 1.3.x for this to work"
  exit 1
fi
TAG=`git describe --tags`
echo Generating documentation for commit/tag: $TAG
rm -rf htmldocs/*
nim doc --project --outdir:htmldocs --index:on --git.url:https://github.com/gokr/norx --git.commit:$TAG src/norx.nim
