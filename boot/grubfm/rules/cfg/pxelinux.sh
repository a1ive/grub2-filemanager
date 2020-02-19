source ${prefix}/func.sh;

set root=${grubfm_device};
export theme=${theme_std};
syslinux_configfile -p "${grubfm_file}";
