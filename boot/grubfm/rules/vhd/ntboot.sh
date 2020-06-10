source ${prefix}/func.sh;
set lang=en_US;
terminal_output console;
loopback wimboot ${prefix}/wimboot.gz;
if [ "$grub_platform" = "efi" ];
then
  ntboot --vhd --gui \
         --efi=(wimboot)/bootmgfw.efi \
         "${grubfm_file}";
elif [ "$grub_platform" = "pc" ];
then
  ntboot --vhd "${grubfm_file}";
  linux16 (wimboot)/wimboot gui rawbcd;
  initrd16 newc:bootmgr.exe:(wimboot)/bootmgr.exe \
           newc:bcd:(proc)/bcd;
  set gfxmode=1920x1080,1366x768,1024x768,800x600,auto;
  terminal_output gfxterm;
  boot;
fi;
