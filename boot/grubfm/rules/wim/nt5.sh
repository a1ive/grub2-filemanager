source ${prefix}/func.sh;


to_g4d_path "${grubfm_file}";
if [ -n "${g4d_path}" ];
then
  set g4d_cmd="map --mem (rd)+1 (fd0);map --hook;configfile (fd0)/menu.lst";
  to_g4d_menu "set file=${g4d_path}\x0a(fd0)/NTBOOT pe1=%file%";
  linux (rd)/NTBOOT.MOD/grub.exe --config-file=${g4d_cmd};
  initrd (rd);
  boot;
fi;
