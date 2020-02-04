set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/core.gz";
if test -f (loop)/boot/vmlinuz64; then
    vmlinuz_img="(loop)/boot/vmlinuz64";
    initrd_img="(loop)/boot/corepure64.gz";
fi
set kcmdline="loglevel=3 cde vga=791";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
