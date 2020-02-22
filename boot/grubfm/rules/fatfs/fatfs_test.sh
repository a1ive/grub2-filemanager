source ${prefix}/func.sh;

probe --set=fs --fs "(${grubfm_device})";
if [ "${fs}" = "fat" ];
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
