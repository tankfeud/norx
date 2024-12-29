# Generate HTML docs
CHECK=`echo "Nim Version 1.4.44" | egrep "Version 1\.[3-9]\."`
if [ -z "$CHECK" ]
then
  echo "Need at least Nim version 1.3.x for this to work"
  exit 1
fi

