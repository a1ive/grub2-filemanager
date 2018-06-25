#!/usr/bin/env sh
sbsign --key test-cert.key --cert test-cert.crt grubfmx64.efi
sbsign --key test-cert.key --cert test-cert.crt grubfmia32.efi
