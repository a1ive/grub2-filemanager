source ${prefix}/func.sh;

if ! regexp 'hd[0-9]+,msdos[1-3]' "${grubfm_device}";
then
  return;
fi;

probe --set=fs -f "${grubfm_device}";
if [ "${fs}" != "fat" -a "${fs}" != "exfat" -a "${fs}" != "ntfs" ];
then
  return;
fi;

set grubfm_test=1;
