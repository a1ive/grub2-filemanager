source ${prefix}/func.sh;

if [ -f "(${grubfm_device})${grubfm_dir}${grubfm_filename}.grubfm" ];
then
  set grubfm_test=1;
else
  set grubfm_test=0;
fi;

# hide user menu for *grubfm
if regexp '[gG][rR][uU][bB][fF][mM]' "${grubfm_fileext}";
then
  set grubfm_test=0;
fi;
