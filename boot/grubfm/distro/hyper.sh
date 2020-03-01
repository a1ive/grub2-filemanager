set vmlinuz_img="(loop)/hyperbola/boot/x86_64/vmlinuz";
set initrd_img="(loop)/hyperbola/boot/x86_64/hyperiso.img";
set kcmdline="hyperisobasedir=hyperbola earlymodules=loop";

linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
