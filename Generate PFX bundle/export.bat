@echo off

set openssl=D:\Development\openssl

set PATH=%openssl%\bin;


openssl pkcs12 -in cert.pfx -out cert.key

openssl pkcs12 -export -out certfiletosignwith.pfx -keysig -in backupcertfile.key
@pause