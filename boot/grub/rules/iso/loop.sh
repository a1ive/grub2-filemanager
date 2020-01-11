source ${prefix}/func.sh;

loopback -d loop;
loopback loop "${grubfm_file}";
probe --set=rootuuid -u "(${grubfm_device})";
export iso_path="${grubfm_path}";
export rootuuid;
export theme=${prefix}/themes/slack/theme.txt;
set root=loop;
configfile /boot/grub/loopback.cfg;
