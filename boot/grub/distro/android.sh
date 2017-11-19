set vmlinuz_img="(loop)/kernel";
set initrd_img="(loop)/initrd.img";
set kcmdline="androidboot.selinux=permissive";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
