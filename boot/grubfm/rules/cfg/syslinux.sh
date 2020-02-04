source ${prefix}/func.sh;

set root=${grubfm_device};
export theme=${prefix}/themes/slack/theme.txt;
syslinux_configfile -s "${grubfm_file}";
