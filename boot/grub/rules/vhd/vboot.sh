source ${prefix}/func.sh;

probe --set=dev_uuid -u "(${grubfm_device})";
loopback vboot ${prefix}/vbootldr.gz;
set vbootloader=(vboot)/vboot;
vbootinsmod (vboot)/vbootcore.mod;
vboot "harddisk=(UUID=${dev_uuid})${grubfm_path}";
boot;
