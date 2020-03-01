set vmlinuz_img="(loop)/boot/isolinux/linux";
set initrd_img="(loop)/boot/isolinux/minirt.gz";
set kcmdline="ramdisk_size=100000 lang=en apm=power-off nomce libata.force=noncq hpsa.hpsa_allow_any=1 loglevel=1 tz=localtime";
set linux_extra="bootfrom=${imgdevpath}${isofile}";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
