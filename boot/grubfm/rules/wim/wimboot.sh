set lang=en_US;
terminal_output console;
loopback wimboot ${prefix}/wimboot.gz;
if [ "$grub_platform" = "efi" ];
then
  wimboot --rawwim \
          @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
          @:bcd:(wimboot)/bcd \
          @:boot.sdi:(wimboot)/boot.sdi \
          @:boot.wim:"${grubfm_file}";
elif [ "$grub_platform" = "pc" ];
then
  set enable_progress_indicator=1;
  linux16 (wimboot)/wimboot rawwim;
  initrd16 newc:bootmgr.exe:(wimboot)/bootmgr.exe \
           newc:bcd:(wimboot)/bcd \
           newc:boot.sdi:(wimboot)/boot.sdi \
           newc:boot.wim:"${grubfm_file}";
  set gfxmode=1920x1080,1366x768,1024x768,800x600,auto;
  terminal_output gfxterm;
  boot;
fi;
