@echo off

set openssl=D:\Development\openssl

set PATH=%openssl%\bin;
SET output=%~dp0output

openssl pkcs12 -passout pass:"<enterpass>" -export -out "%output%/cert.pfx" -inkey "%output%\cert.key" -in "%output%\cert-SHA2-main.crt"

@pause