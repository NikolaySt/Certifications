@echo off
set PATH=d:\OpenSsl\bin
set RANDFILE=d:\OpenSsl\.rnd


rem openssl s_client -connect localhost:44330
rem openssl ocsp -issuer ".build/dbserver.pem -cert dbclient.pem

rem openssl ocsp -issuer "./build/dbserver.pem" -cert "./build/dbclient.pem"
rem openssl ocsp -CAfile "./ca/ca.crt" -url http://127.0.0.1:8888 -resp_text -issuer "./intermediate/intermediate.crt" -cert "./build/dbclient.crt"
rem openssl ocsp -url http://127.0.0.1:8888 
rem openssl s_client -connect www.akamai.com:443

rem openssl ocsp -CAfile "./ca/ca.pem" -issuer "./intermediate/intermediate.pem" -cert "./build/dbclient.pem" -url http://127.0.0.1:80 -resp_text -respout resp.der	  
rem openssl ocsp -issuer "./intermediate/intermediate-chain.pem" -cert "./build/dbclient.pem" -text -url http://127.0.0.1:8888
openssl ocsp -issuer "./intermediate/intermediate.pem" -cert "./build/dbclient-chain.pem" -text -url http://127.0.0.1:8888
@pause