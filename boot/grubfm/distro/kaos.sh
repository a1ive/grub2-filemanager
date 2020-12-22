export enable_progress_indicator=1;
set vmlinuz_img="(loop)/kdeos/boot/x86_64/kdeosiso";
set initrd_img="(loop)/kdeos/boot/x86_64/kdeosiso.img";
set kcmdline="kdeosisodevice=/dev/loop0 earlymodules=loop";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
