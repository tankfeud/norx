echo "Use username and password \"norxdemo\", or edit the key.properties file with whatever you use."
keytool -genkey -v -keystore norxdemo-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
echo "DO NOT FORGET: Copy ./build/android-native/key.properties.sample to ./build/android-native/key.properties end edit with whatever passwords you used."
