source ${prefix}/func.sh;

set root=${grubfm_device};
export theme=${prefix}/themes/slack/theme.txt;
legacy_configfile "${grubfm_file}";
