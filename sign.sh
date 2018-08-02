#!/usr/bin/env sh
sbsign --key test-cert.key --cert test-cert.crt grubfmx64.efi
sbsign --key test-cert.key --cert test-cert.crt grubfmia32.efi
mv grubfmx64.efi.signed grubfmx64.efi
mv grubfmia32.efi.signed grubfmia32.efi
