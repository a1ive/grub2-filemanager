set lang=en_US;
terminal_output console;
loopback wimboot ${prefix}/wimboot.gz;
wimboot --rawwim \
        @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
        @:boot.wim:"${grubfm_file}";
