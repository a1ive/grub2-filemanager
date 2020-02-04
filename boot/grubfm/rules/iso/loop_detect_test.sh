source ${prefix}/func.sh;

if regexp '^hd.*' "${grubfm_device}";
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
