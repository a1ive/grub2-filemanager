set lang=en_US;
if [ "$grub_platform" = "efi" ];
then
  loopback wimboot ${prefix}/wimboot.gz;
  wimboot @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
          @:bcd:(wimboot)/bcd \
          @:boot.sdi:(wimboot)/boot.sdi \
          @:boot.wim:"${grubfm_file}";
elif [ "$grub_platform" = "pc" ];
then
  terminal_output console;
  set enable_progress_indicator=1;
  loopback wimboot /wimboot;
  linux16 (wimboot)/wimboot;
  initrd16 newc:bootmgr:(wimboot)/bootmgr \
           newc:bootmgr.exe:(wimboot)/bootmgr.exe \
           newc:bcd:(wimboot)/bcd \
           newc:boot.sdi:(wimboot)/boot.sdi \
           newc:boot.wim:"${grubfm_file}";
fi;
