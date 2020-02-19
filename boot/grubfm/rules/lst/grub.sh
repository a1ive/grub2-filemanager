source ${prefix}/func.sh;

set root=${grubfm_device};
export theme=${theme_std};
legacy_configfile "${grubfm_file}";
