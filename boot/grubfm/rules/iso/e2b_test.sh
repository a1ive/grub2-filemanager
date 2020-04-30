source ${prefix}/func.sh;

probe --set=fs -f "${grubfm_device}";
if [ "${fs}" != "fat" -a "${fs}" != "exfat" -a "${fs}" != "ntfs" ];
then
  return;
fi;
probe --set=partmap -p "${grubfm_device}";
if [ "${partmap}" != "msdos" ];
then
  return;
fi;

if regexp 'hd[0-9]+,[a-zA-Z]*[1-3]' "${grubfm_device}";
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
