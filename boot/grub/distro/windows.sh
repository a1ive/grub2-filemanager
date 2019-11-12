set icon="nt6";
function win_isoboot {
  set lang=en_US;
  set installiso="${linux_extra}";
  if [ "$grub_platform" = "pc" ]; then
      terminal_output console;
      set enable_progress_indicator=1;
      loopback wimboot /wimboot;
      loopback install /install.gz;
      save_env -f (memdisk)/null.cfg installiso;
      linux16 (wimboot)/wimboot;
      initrd16 newc:bootmgr:(loop)/bootmgr \
               newc:bcd:(wimboot)/bcd \
               newc:boot.sdi:(loop)/boot/boot.sdi \
               newc:null.cfg:(memdisk)/null.cfg \
               newc:mount_x64.exe:(install)/mount_x64.exe \
               newc:mount_x86.exe:(install)/mount_x86.exe \
               newc:start.bat:(install)/start.bat \
               newc:winpeshl.ini:(install)/winpeshl.ini \
               newc:boot.wim:"${1}";
      cat (memdisk)/null.cfg;
      boot;
  else
      loopback wimboot ${prefix}/wimboot.gz;
      loopback install ${prefix}/install.gz;
      save_env -f ${prefix}/null.cfg installiso;
      cat ${prefix}/null.cfg;
      wimboot @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
              @:bcd:(wimboot)/bcd \
              @:boot.sdi:(wimboot)/boot.sdi \
              @:null.cfg:${prefix}/null.cfg \
              @:mount_x64.exe:(install)/mount_x64.exe \
              @:mount_x86.exe:(install)/mount_x86.exe \
              @:start.bat:(install)/start.bat \
              @:winpeshl.ini:(install)/winpeshl.ini \
              @:boot.wim:"${1}";
  fi;
}

if test -f (loop)/sources/boot.wim; then
  win_isoboot "(loop)/sources/boot.wim";
else
  if test -f (loop)/x64/sources/boot.wim; then
    menuentry $"Install Windows (x64)" --class ${icon} {
      win_isoboot "(loop)/x64/sources/boot.wim";
    }
  fi;
  if test -f (loop)/x86/sources/boot.wim; then
    menuentry $"Install Windows (x86)" --class ${icon} {
      win_isoboot "(loop)/x86/sources/boot.wim";
    }
  fi;
fi;
