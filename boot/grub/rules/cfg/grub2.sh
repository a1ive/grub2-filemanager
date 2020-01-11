source ${prefix}/func.sh;

set root=${grubfm_device};
export theme=${prefix}/themes/slack/theme.txt;
configfile "${grubfm_file}";
