set vmlinuz_img="(loop)/slax/boot/vmlinuz";
set initrd_img="(loop)/slax/boot/initr*";
if test -f (loop)/boot/vmlinuz; then
    vmlinuz_img="(loop)/boot/vmlinuz";
    initrd_img="(loop)/boot/initr*";
fi
set kcmdline="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 slax.flags=xmode";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
