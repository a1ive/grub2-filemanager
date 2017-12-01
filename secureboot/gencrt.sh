#!/usr/bin/env sh
openssl genrsa -out test-key.rsa 2048
openssl req -new -x509 -days 36500 -sha256 -subj '/CN=GRUBFM' -key test-key.rsa -out test-cert.pem
openssl x509 -in test-cert.pem -inform PEM -out test-cert.der -outform DER
