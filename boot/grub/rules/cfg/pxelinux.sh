source ${prefix}/func.sh;

set root=${grubfm_device};
syslinux_configfile -p "${grubfm_file}";
