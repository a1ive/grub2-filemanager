source ${prefix}/func.sh;

if [ -z "${grubfm_startbat}" -o ! -f "${grubfm_startbat}" ];
then
  set grubfm_startbat="(install)/start.bat";
fi;

function win_isoboot {
  set lang=en_US;
  terminal_output console;
  set installiso="${grubfm_path}";
  tr --set=installiso "/" "\\";
  loopback -m envblk ${prefix}/null.cpio;
  save_env -s -f (envblk)/null.cfg installiso;
  cat (envblk)/null.cfg;
  loopback wimboot ${prefix}/wimboot.xz;
  loopback install ${prefix}/install.xz;
  swap_hd01;
  if [ -z "${2}" ];
  then
    wimboot --highest=no --testmode=no \
            @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
            @:null.cfg:(envblk)/null.cfg \
            @:mount_x64.exe:(install)/mount_x64.exe \
            @:mount_x86.exe:(install)/mount_x86.exe \
            @:start.bat:${grubfm_startbat} \
            @:winpeshl.ini:(install)/winpeshl.ini \
            @:boot.wim:"${1}";
  else
    wimboot --highest=no --testmode=no \
            @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
            @:null.cfg:(envblk)/null.cfg \
            @:mount_x64.exe:(install)/mount_x64.exe \
            @:mount_x86.exe:(install)/mount_x86.exe \
            @:start.bat:${grubfm_startbat} \
            @:winpeshl.ini:(install)/winpeshl.ini \
            @:autounattend.xml:"${2}" \
            @:boot.wim:"${1}";
  fi;
}

function xml_list {
  # autounattend.xml
  if [ -f "(${grubfm_device})${grubfm_dir}"*.xml ];
  then
    clear_menu;
    menuentry $"Install Windows without autounattend.xml" "${1}" --class nt6 {
      win_isoboot "${2}";
    }
    for xml in "(${grubfm_device})${grubfm_dir}"*.xml;
    do
      regexp --set=1:xml_name '^.*/(.*)$' "${xml}";
      menuentry $"Load ${xml_name}" "${1}" "${xml}" --class nt6 {
        win_isoboot "${2}" "${3}";
      }
    done;
    source ${prefix}/global.sh;
  else
    win_isoboot "${1}";
  fi;
}

if test -f (loop)/sources/boot.wim; then
  xml_list "(loop)/sources/boot.wim";
else
  if test -f (loop)/x64/sources/boot.wim; then
    menuentry $"Install Windows (x64)" --class nt6 {
      xml_list "(loop)/x64/sources/boot.wim";
    }
  fi;
  if test -f (loop)/x86/sources/boot.wim; then
    menuentry $"Install Windows (x86)" --class nt6 {
      xml_list "(loop)/x86/sources/boot.wim";
    }
  fi;
  source ${prefix}/global.sh;
fi;
