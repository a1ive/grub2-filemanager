source ${prefix}/func.sh;

stat --set=frag -c -q "${grubfm_file}";
if [ "${frag}" != "1" ];
then
  echo $"ERROR:"
  echo $"File is non-contiguous. (${frag} fragments)";
  sleep 3;
  return;
fi;

if [ -d (${grubfm_disk},4) ];
then
  echo $"WARNING: Will erase ALL data on (${grubfm_disk},4)";
  echo $"Press [1] to continue. Press any other key to return.";
  getkey key;
else
  key=49;
fi;
if [ x$key = x49 ];
then
  partnew --type=0x00 --file="${grubfm_file}" "${grubfm_disk}" 4;
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
  echo $"Canceled.";
  sleep 3;
fi;
