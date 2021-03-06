@echo off

set openssl=D:\Development\openssl

set PATH=%openssl%\bin;
SET output=%~dp0build

@echo Issue CA
rem goto disableCA

openssl genrsa -out ./ca/ca.key 4096 
openssl req -subj "/C=US/O=Orionswave Ltd./OU=Orionswave Certification Authority" -config openssl-ca.cnf -key ./ca/ca.key -new -x509 -days 7300 -sha256 -extensions v3_ca -out ./ca/ca.crt
openssl x509 -noout -text -in ./ca/ca.crt
:disableCA

@echo Issue Intermediate
rem goto disableIntermediate
openssl genrsa -out ./intermediate/intermediate.key 4096
openssl req -subj "/C=US/ST=Washington/L=Seattle/O=Orionswave Ltd./OU=Unit/CN=Orionswave Certification Authority" -config openssl-intermedia.cnf -new -sha256 -key ./intermediate/intermediate.key -out ./intermediate/intermediate.csr
openssl ca -config openssl-ca.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in ./intermediate/intermediate.csr -out ./intermediate/intermediate.crt
:disableIntermediate

@echo Issue DB Server Certificate
rem goto disableDBServerCertificate
openssl genrsa -out "%output%\dbserver.key" 2048
openssl req -subj "/C=US/ST=Washington/L=Seattle/O=Orionswave Ltd./OU=Orionswave Deployment" -config openssl-intermedia.cnf -key "%output%\dbserver.key" -new -sha256 -out "%output%\dbserver.req"
openssl ca -batch -config openssl-intermedia.cnf -extensions server_cert -days 375 -notext -md sha256 -in "%output%\dbserver.req" -out "%output%\dbserver.crt"
:disableDBServerCertificate

@echo Issue DB Client Certificate
rem goto disableDBClientCertificate
openssl genrsa -out "%output%\dbclient.key" 2048
openssl req -subj "/C=US/ST=Washington/L=Seattle/O=Orionswave Corp./OU=Orionswave Client" -config openssl-intermedia.cnf -key "%output%\dbclient.key" -new -sha256 -out "%output%\dbclient.req"
openssl ca -batch -config openssl-intermedia.cnf -extensions client_cert -days 375 -notext -md sha256 -in "%output%\dbclient.req" -out "%output%\dbclient.crt"
:disableDBClientCertificate

@echo Combine
copy .\ca\ca.key+.\ca\ca.crt .\ca\ca.pem
copy .\intermediate\intermediate.key+.\intermediate\intermediate.crt .\intermediate\intermediate.pem
copy .\ca\ca.crt+.\intermediate\intermediate.crt .\intermediate\intermediate-chain.pem
copy ".\intermediate\intermediate.crt"+".\ca\ca.crt" "%output%\ca-chain.pem"

copy "%output%\dbserver.key"+"%output%\dbserver.crt" "%output%\dbserver.pem"
copy "%output%\dbserver.crt"+"%output%\dbserver.key" "%output%\dbserver-revert.pem"
copy "%output%\dbserver.crt"+".\intermediate\intermediate.crt"+".\ca\ca.crt" "%output%\dbserver-chain.pem"

copy "%output%\dbclient.key"+"%output%\dbclient.crt" "%output%\dbclient.pem"
copy "%output%\dbclient.crt"+"%output%\dbclient.key" "%output%\dbclient-revert.pem"
copy "%output%\dbclient.crt"+".\intermediate\intermediate.crt"+".\ca\ca.crt" "%output%\dbclient-chain.pem"

openssl pkcs12 -passout pass: -export -out "%output%\server.pfx" -inkey "%output%\dbserver.key" -in "%output%\dbserver-chain.pem" -name Server
openssl pkcs12 -passout pass: -export -out "%output%\client.pfx" -inkey "%output%\dbclient.key" -in "%output%\dbclient-chain.pem" -name Client

echo Information
openssl x509 -noout -text -in "./ca/ca.crt"
openssl x509 -noout -text -in "./intermediate/intermediate.crt"
openssl x509 -noout -text -in "%output%\dbserver.crt"
openssl x509 -noout -text -in "%output%\dbclient.crt"

echo Verify Certificates
openssl verify -verbose -CAfile "./ca/ca.crt" "./intermediate/intermediate.crt"
openssl verify -verbose -CAfile "./intermediate/intermediate-chain.pem" "%output%\dbserver.pem"
openssl verify -verbose -CAfile "./intermediate/intermediate-chain.pem" "%output%\dbclient.pem"
openssl verify -verbose -CAfile "%output%\dbserver-chain.pem" "%output%\dbserver.crt"
openssl verify -verbose -CAfile "%output%\dbclient-chain.pem" "%output%\dbclient.crt"

@pause