source ${prefix}/func.sh;

set root=${grubfm_device};
syslinux_configfile -s "${grubfm_file}";
