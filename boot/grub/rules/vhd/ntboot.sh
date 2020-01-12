source ${prefix}/func.sh;

if [ "$grub_platform" = "efi" ];
then
  set lang=en_US;
  terminal_output console;
  loopback wimboot ${prefix}/wimboot.gz;
  ntboot --gui \
         --efi=(wimboot)/bootmgfw.efi \
         "${grubfm_file}";
elif [ "$grub_platform" = "pc" ];
then
  to_g4d_path "${grubfm_file}";
  if [ -n "${g4d_path}" ];
  then
    set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/NTBOOT NT6=${g4d_path};";
    linux ${prefix}/grub.exe --config-file=${g4d_cmd};
    boot;
  fi;
fi;
