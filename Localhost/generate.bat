set openssl=D:\Development\openssl
set PATH=%openssl%\bin;

@rem DOES NOT WORK

openssl genrsa -out localhost.key 4096 
rem openssl req -x509 -out localhost.crt -key localhost.key -new -days 7300 -nodes -sha256 -subj '/CN=localhost' -extensions v3_ca -config config.cnf
rem openssl x509 -noout -text -in localhost.crt

openssl req -x509 -out localhost.crt -key localhost.key -new -nodes -sha256 -subj '/CN=localhost' -extensions v3_ca -config config.cnf
rem openssl req -x509 -out localhost.crt -keyout localhost.key -newkey rsa:2048 -nodes -sha256 -subj '/CN=localhost' -extensions v3_ca -config config.cnf
rem openssl x509 -noout -text -in localhost.crt


@pause