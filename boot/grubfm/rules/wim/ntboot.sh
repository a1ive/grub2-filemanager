source ${prefix}/func.sh;
set lang=en_US;
terminal_output console;
loopback wimboot ${prefix}/wimboot.gz;
if [ "$grub_platform" = "efi" ];
then
  ntboot --efi=(wimboot)/bootmgfw.efi "${grubfm_file}";
fi;
