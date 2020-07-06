source ${prefix}/func.sh;
set lang=en_US;
terminal_output console;
loopback wimboot ${prefix}/wimboot.xz;
ntboot --vhd --efi=(wimboot)/bootmgfw.efi "${grubfm_file}";
