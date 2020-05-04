source ${prefix}/func.sh;

if regexp 'hd[0-9]+,[msdos]*[1-3]' "${grubfm_device}";
then
  set grubfm_test=1;
fi;

probe --set=partmap -p "${grubfm_device}";
if [ "${partmap}" = "msdos" -a "${grubfm_test}" = "1" ];
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
