if [ -f "${theme_std}" ];
then
  export theme=${theme_std};
fi;
configfile "(${grubfm_device})${grubfm_dir}${grubfm_filename}.grubfm";
