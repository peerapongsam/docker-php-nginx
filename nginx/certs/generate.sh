#/bin/sh
DNS_NAME=localhost
# 1. Create a config
echo "[req]
default_bits = 4096
distinguished_name = req_distinguished_name
req_extensions = req_ext
prompt = no

[req_distinguished_name]
C = TH
ST = Bangkok
L = Phaya Thai
O = Internet Marketing Co.,Ltd.
OU = Software Engineering
CN = ${DNS_NAME}

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DNS_NAME}
DNS.2 = *.dev.localhost
IP.1 = 127.0.0.1
IP.2 = 192.168.43.105
" > ${DNS_NAME}.conf

# 1. Generate a private key:
openssl genrsa -out ${DNS_NAME}.key 4096

# 2. Generate a Certificate Signing Request:
openssl req -new -sha256 \
 -out ${DNS_NAME}.csr \
 -key ${DNS_NAME}.key \
 -config ${DNS_NAME}.conf

# 3. Generate the certificate
openssl x509 -req \
 -days 3650 \
 -in ${DNS_NAME}.csr \
 -signkey ${DNS_NAME}.key \
 -out ${DNS_NAME}.crt \
 -extensions req_ext \
 -extfile ${DNS_NAME}.conf
 