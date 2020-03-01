source ${prefix}/func.sh;

if [ "$grub_platform" = "efi" ];
then
  vhd -d vhd0; vhd -p vhd0 "${grubfm_file}";
  map --type=HD --disk vhd0;
elif [ "$grub_platform" = "pc" ];
then
  to_g4d_path "${grubfm_file}";
  if [ -n "${g4d_path}" ];
  then
    set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/MAP nomem hd ${g4d_path};";
    linux ${prefix}/grub.exe --config-file=${g4d_cmd};
  fi;
fi;
