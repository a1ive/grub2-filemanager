set vmlinuz_img="(loop)/boot/syslinux/vmlinuz";
set initrd_img="(loop)/boot/syslinux/initrd*";
if test -f (loop)/porteus/vmlinuz; then
    set vmlinuz_img="(loop)/porteus/vmlinuz";
    set initrd_img="(loop)/porteus/initrd*";
fi
set kcmdline="norootcopy nomagic";
linux $vmlinuz_img $kcmdline $linux_extra;
if test -f $initrd_img; then
    initrd $initrd_img;
fi;
