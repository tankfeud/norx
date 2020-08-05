echo "Use username and password \"norxdemo\", or edit the key.properties file with whatever you use."
keytool -genkey -v -keystore norxdemo-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
