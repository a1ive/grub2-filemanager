source ${prefix}/func.sh;

if [ "$grub_platform" = "efi" ];
then
  map --type=FD "${grubfm_file}";
elif [ "$grub_platform" = "pc" ];
then
  to_g4d_path "${grubfm_file}";
  if [ -n "${g4d_path}" ];
  then
    set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/MAP nomem fd ${g4d_path};";
    linux ${prefix}/grub.exe --config-file=${g4d_cmd};
  else
    set enable_progress_indicator=1;
    linux16 ${prefix}/memdisk floppy raw;
    initrd16 "${grubfm_file}";
  fi;
  boot;
fi;
