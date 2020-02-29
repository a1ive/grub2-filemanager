source ${prefix}/func.sh;

echo $"Enter the name";
read name;
echo "";
if regexp '[/\\:\*\?\$]' "${name}";
then
  echo $"Bad file name.";
  echo $"Press any key to exit.";
  getkey;
else
  set path="${grubfm_dir}${name}";
  umount 9;
  mount (${grubfm_device}) 9;
  rename "9:/${grubfm_path}" "9:/${path}";
  umount 9;
  grubfm "(${grubfm_device})${grubfm_dir}";
fi;
