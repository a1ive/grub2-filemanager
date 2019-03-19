set vmlinuz_img="(loop)/isolinux/vmlinuz";
set initrd_img="(loop)/isolinux/initrd.gz";
set kcmdline="keyb=us splash=verbose livecd=livecd";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
