source ${prefix}/func.sh;

to_g4d_path "${grubfm_file}";
if [ -n "${g4d_path}" ];
then
  set g4d_cmd="map --mem --top ${g4d_path} (hd0); map (hd0) (hd1); map --hook; root (hd0,0); chainloader /bootmgr; boot"
  linux ${prefix}/grub.exe --config-file=${g4d_cmd};
fi;
