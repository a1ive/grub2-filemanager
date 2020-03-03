source ${prefix}/func.sh;

probe --set=fs -f "${grubfm_device}";
if [ "${fs}" != "fat" -a "${fs}" != "exfat" -a "${fs}" != "ntfs" ];
then
  return;
fi;

if regexp 'hd[0-9]+,msdos[1-3]' "${grubfm_device}";
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
