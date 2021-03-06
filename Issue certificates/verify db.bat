start mongod --dbpath ./data --sslMode requireSSL --sslPEMKeyFile ./build/dbserver.pem --sslCAFile ./build/dbserver-chain.pem --smallfiles --oplogSize 128 --nojournal

TIMEOUT 10

start mongo localhost --ssl --sslPEMKeyFile ./build/dbclient.pem --sslCAFile ./build/dbclient-chain.pem
REM --sslAllowInvalidHostnames
