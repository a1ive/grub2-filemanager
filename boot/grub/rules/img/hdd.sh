source ${prefix}/func.sh;

if [ "$grub_platform" = "efi" ];
then
  map "${grubfm_file}";
elif [ "$grub_platform" = "pc" ];
then
  to_g4d_path "${grubfm_file}";
  if [ -n "${g4d_path}" ];
  then
    set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/MAP nomem hd ${g4d_path};";
    linux ${prefix}/grub.exe --config-file=${g4d_cmd};
  else
    set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/MAP nomem hd (rd)+1;";
    set enable_progress_indicator=1;
    linux ${prefix}/grub.exe --config-file=${g4d_cmd};
    initrd "${grubfm_file}";
  fi;
  boot;
fi;
