source ${prefix}/func.sh;
to_g4d_path "${grubfm_file}";
set g4d_cmd="map --mem (rd)+1 (fd0);map --mem (rd)+1 (fd1);map --hook;configfile (fd0)/menu.lst";

menuentry $"Install Windows XP - STEP 1" --class nt5 {
  to_g4d_menu "set file=${g4d_path}\x0amap %file% (0xff) || map --mem %file% (0xff)\x0amap (hd0) (hd1)\x0amap (hd1) (hd0)\x0amap --hook\x0achainloader (0xff)\x0aboot";
  linux ${prefix}/grub.exe --config-file=${g4d_cmd};
  initrd (rd);
}

menuentry $"Install Windows XP - STEP 2" --class nt5 {
  to_g4d_menu "set file=${g4d_path}\x0amap %file% (0xff) || map --mem %file% (0xff)\x0amap (hd0) (hd1)\x0amap (hd1) (hd0)\x0amap --hook\x0arootnoverify (hd0)\x0achainloader +1\x0aboot";
  linux ${prefix}/grub.exe --config-file=${g4d_cmd};
  initrd (rd);
}
