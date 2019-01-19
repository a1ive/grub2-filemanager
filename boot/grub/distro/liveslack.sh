set vmlinuz_img="(loop)/boot/generic";
set initrd_img="(loop)/boot/initrd.img";
set kcmdline="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
