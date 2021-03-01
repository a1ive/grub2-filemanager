source ${prefix}/func.sh;

loopback -d loop;
loopback loop "${grubfm_file}";
probe --set=rootuuid -u "(${grubfm_device})";
export iso_path="${grubfm_path}";
export rootuuid;
if [ -f "${theme_std}" ];
then
  export theme=${theme_std};
fi;
export root=loop;
configfile /boot/grub/loopback.cfg;
