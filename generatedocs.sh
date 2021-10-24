# Generate HTML docs
CHECK=`echo "Nim Version 1.4.44" | egrep "Version 1\.[3-9]\."`
if [ -z "$CHECK" ]
then
  echo "Need at least Nim version 1.3.x for this to work"
  exit 1
fi
TAG=`git describe --tags`
echo Generating documentation for commit/tag: $TAG
rm -rf htmldocs/*
nim doc --project --outdir:htmldocs --index:on --git.url:https://github.com/tankfeud/norx --git.commit:$TAG src/norx.nim
