set lang=en_US;
terminal_output console;
loopback wimboot ${prefix}/wimboot.xz;
wimboot --rawwim \
        @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
        @:boot.wim:"${grubfm_file}";
