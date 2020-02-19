source ${prefix}/func.sh;

set root=${grubfm_device};
if [ -f "${theme_std}" ];
then
  export theme=${theme_std};
fi;
configfile "${grubfm_file}";
