source ${prefix}/func.sh;

echo "WARNING: Will delete ${grubfm_file}";
echo "Press [1] to continue. Press any other key to return.";
getkey key;
if [ x$key = x49 ];
then
  umount 9;
  mount (${grubfm_device}) 9;
  rm "9:/${grubfm_path}";
  umount 9;
  echo $"Press any key to back.";
  getkey;
  grubfm "(${grubfm_device})${grubfm_dir}";
fi;
