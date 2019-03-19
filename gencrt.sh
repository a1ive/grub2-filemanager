#!/usr/bin/env sh
openssl req -newkey rsa:2048 -nodes -keyout test-cert.key -config ./secureboot/openssl.cnf -new -x509 -sha256 -days 36500 -subj "/CN=a1ive@github" -out test-cert.crt
openssl x509 -in test-cert.crt -out test-cert.cer -outform DER
#sbsign --key test-cert.key --cert test-cert.crt grubfmx64.efi
