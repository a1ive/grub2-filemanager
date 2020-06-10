source ${prefix}/func.sh;
set lang=en_US;
terminal_output console;
loopback wimboot ${prefix}/wimboot.gz;
if [ "$grub_platform" = "efi" ];
then
  ntboot --efi=(wimboot)/bootmgfw.efi \
         --sdi=(wimboot)/boot.sdi \
         "${grubfm_file}";
elif [ "$grub_platform" = "pc" ];
then
  ntboot --wim "${grubfm_file}";
  linux16 (wimboot)/wimboot;
  initrd16 newc:bootmgr.exe:(wimboot)/bootmgr.exe \
           newc:bcd:(proc)/bcd \
           newc:boot.sdi:(wimboot)/boot.sdi;
  set gfxmode=1920x1080,1366x768,1024x768,800x600,auto;
  terminal_output gfxterm;
  boot;
fi;
