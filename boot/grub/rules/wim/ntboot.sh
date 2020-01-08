function to_g4d_path {
  if regexp --set=1:num '^\(hd[0-9]+,[a-zA-Z]*([0-9]+)\).*' "${1}";
  then
    # (hdx,msdosy) (hdx,gpty) (hdx,y)
    expr --set=num "${num} - 1";
    regexp --set=1:path_1 --set=2:path_2 '^(\(hd[0-9]+,)[a-zA-Z]*[0-9]+(\).*)' "${1}";
    set g4d_path="${path_1}${num}${path_2}";
  elif regexp '^\([chf]d[0-9]*\).*' "${1}";
  then
    # (hd) (cd) (fd) (hdx) (cdx) (fdx)
    set g4d_path="${1}";
  else
    unset g4d_path;
  fi;
}

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
