set vmlinuz_img="(loop)/boot/isolinux/linux";
set initrd_img="(loop)/boot/isolinux/minirt.gz";
set kcmdline="ramdisk_size=100000 lang=en apm=power-off nomce libata.force=noncq hpsa.hpsa_allow_any=1 loglevel=1 tz=localtime";
if [ "$grub_platform" = "pc" ];
then
  set linux_suffix=16;
else
  set linux_suffix=;
fi;
linux$linux_suffix $vmlinuz_img $kcmdline $linux_extra;
initrd$linux_suffix $initrd_img;
