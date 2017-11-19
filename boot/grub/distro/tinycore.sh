set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/core.gz";
set kcmdline="loglevel=3 cde showapps";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
