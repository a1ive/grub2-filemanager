regexp --set=1:iso_device '^(\([0-9a-zA-Z,]+\))/.*' "${grubfm_file}";
if regexp 'hd[0-9]+,msdos[1-3]' "${iso_device}";
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;
