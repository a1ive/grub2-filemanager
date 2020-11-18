source ${prefix}/func.sh;

if [ "$grub_platform" = "efi" ];
then
  map --type=HD "${grubfm_file}";
else
  to_g4d_path "${grubfm_file}";
  if [ -n "${g4d_path}" ];
  then
    set g4d_cmd="map --mem (rd)+1 (fd0);map --hook;configfile (fd0)/menu.lst";
    to_g4d_menu "set file=${g4d_path}\x0amap %file% (hd0) || map --mem %file% (hd0)\x0amap --hook\x0arootnoverify (hd0)\x0achainloader +1\x0aboot";
    linux ${prefix}/grub.exe --config-file=${g4d_cmd};
    initrd (rd);
  else
    set enable_progress_indicator=1;
    linux16 ${prefix}/memdisk harddisk raw;
    initrd16 "${grubfm_file}";
  fi;
  boot;
fi;
