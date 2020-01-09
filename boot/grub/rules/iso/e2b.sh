source ${prefix}/func.sh;

regexp --set=1:dev '(hd[0-9]+),msdos[1-3]' "${grubfm_device}";
echo "WARNING: Will erase ALL data on (${dev},4)";
echo "Press [Y] to continue. Press [N] to quit.";
getkey key;
if [ x$key = x121 ];
then
  partnew --type=0x00 --file="${grubfm_file}" "${dev}" 4;
  if [ "$grub_platform" = "efi" ];
  then
    map "${grubfm_file}";
  elif [ "$grub_platform" = "pc" ];
  then
    to_g4d_path "${grubfm_file}";
    if [ -n "${g4d_path}" ];
    then
      set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/MAP nomem cd ${g4d_path};";
      linux ${prefix}/grub.exe --config-file=${g4d_cmd};
      boot;
    fi;
  fi;
else
  echo "Canceled.";
  sleep 3;
fi;
