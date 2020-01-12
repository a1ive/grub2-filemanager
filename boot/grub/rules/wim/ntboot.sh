source ${prefix}/func.sh;

if [ "$grub_platform" = "efi" ];
then
  set lang=en_US;
  loopback wimboot ${prefix}/wimboot.gz;
  ntboot --efi=(wimboot)/bootmgfw.efi \
         --sdi=(wimboot)/boot.sdi \
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
