
set PATH=d:\OpenSsl\bin
set RANDFILE=d:\OpenSsl\.rnd

openssl x509 -in Certificate.cer -inform DER -out ./temp/Certificate.pem -outform PEM
openssl pkcs12 -nocerts -in Certificate.p12 -out ./temp/Certificate_key.pem
openssl pkcs12 -export -inkey ./temp/Certificate_key.pem -in ./temp/Certificate.pem -out Certificate-iPhone.p12

@pause