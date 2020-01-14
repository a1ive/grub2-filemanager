set vmlinuz_img="(loop)/parabola/boot/x86_64/vmlinuz*";
set initrd_img="(loop)/parabola/boot/x86_64/parabolaiso.img";
set kcmdline="earlymodules=loop";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
