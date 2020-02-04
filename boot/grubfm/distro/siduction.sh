set vmlinuz_img="(loop)/boot/vmlinuz*";
set initrd_img="(loop)/boot/initrd.img*";
set kcmdline="boot=fll fromhd systemd.show_status=1";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
