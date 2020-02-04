source ${prefix}/func.sh;

if regexp 'hd[0-9]+,msdos[1-3]' "${grubfm_device}";
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
