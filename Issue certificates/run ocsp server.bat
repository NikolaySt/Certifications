@echo off
set PATH=d:\OpenSsl\bin
set RANDFILE=d:\OpenSsl\.rnd


openssl ocsp -host 127.0.0.1 -port 8888 -index "./intermediate/index.txt" -rkey "./intermediate/intermediate.key" -rsigner "./intermediate/intermediate.pem" -CA "./ca/ca.pem" -text -out log.txt -nrequest 1
	  
@pause