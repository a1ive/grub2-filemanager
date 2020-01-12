source ${prefix}/func.sh;


to_g4d_path "${grubfm_file}";
if [ -n "${g4d_path}" ];
then
  set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/NTBOOT pe1=${g4d_path};";
  linux ${prefix}/grub.exe --config-file=${g4d_cmd};
  boot;
fi;
