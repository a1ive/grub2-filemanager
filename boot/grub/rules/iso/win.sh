source ${prefix}/func.sh;

function win_isoboot {
  set lang=en_US;
  set installiso="${grubfm_path}";
  tr --set=installiso "/" "\\";
  loopback -m envblk ${prefix}/null.cpio;
  save_env -s -f (envblk)/null.cfg installiso;
  cat (envblk)/null.cfg;
  if [ "$grub_platform" = "pc" ];
  then
    terminal_output console;
    set enable_progress_indicator=1;
    loopback wimboot /wimboot;
    loopback install /install.gz;
    linux16 (wimboot)/wimboot;
    initrd16 newc:bootmgr:(loop)/bootmgr \
             newc:bcd:(wimboot)/bcd \
             newc:boot.sdi:(loop)/boot/boot.sdi \
             newc:null.cfg:(envblk)/null.cfg \
             newc:mount_x64.exe:(install)/mount_x64.exe \
             newc:mount_x86.exe:(install)/mount_x86.exe \
             newc:start.bat:(install)/start.bat \
             newc:winpeshl.ini:(install)/winpeshl.ini \
             newc:boot.wim:"${1}";
    boot;
  else
    loopback wimboot ${prefix}/wimboot.gz;
    loopback install ${prefix}/install.gz;
    wimboot @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
            @:bcd:(wimboot)/bcd \
            @:boot.sdi:(wimboot)/boot.sdi \
            @:null.cfg:(envblk)/null.cfg \
            @:mount_x64.exe:(install)/mount_x64.exe \
            @:mount_x86.exe:(install)/mount_x86.exe \
            @:start.bat:(install)/start.bat \
            @:winpeshl.ini:(install)/winpeshl.ini \
            @:boot.wim:"${1}";
  fi;
}

loopback -d loop;
loopback loop "${grubfm_file}";

if test -f (loop)/sources/boot.wim; then
  win_isoboot "(loop)/sources/boot.wim";
else
  if test -f (loop)/x64/sources/boot.wim; then
    menuentry $"Install Windows (x64)" --class nt6 {
      win_isoboot "(loop)/x64/sources/boot.wim";
    }
  fi;
  if test -f (loop)/x86/sources/boot.wim; then
    menuentry $"Install Windows (x86)" --class nt6 {
      win_isoboot "(loop)/x86/sources/boot.wim";
    }
  fi;
fi;
