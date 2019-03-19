if test -f (loop)/arch/boot/x86_64/vmlinuz* -a -f (loop)/arch/boot/x86_64/archiso.img; then
    set vmlinuz_img="(loop)/arch/boot/x86_64/vmlinuz*";
    set initrd_img="(loop)/arch/boot/x86_64/archiso.img";
    set kcmdline="archisodevice=/dev/loop0 earlymodules=loop";
fi;
if test -f (loop)/boot/vmlinuz_x86_64 -a -f (loop)/boot/initramfs_x86_64.img; then
    set vmlinuz_img="(loop)/boot/vmlinuz_x86_64";
    set initrd_img="(loop)/boot/initramfs_x86_64.img";
    set kcmdline="";
fi;
if test -f (loop)/arch/boot/vmlinuz* -a -f (loop)/arch/boot/archiso.img; then
    set vmlinuz_img="(loop)/arch/boot/vmlinuz*";
    set initrd_img="(loop)/arch/boot/archiso.img";
    set kcmdline="archisobasedir=arch earlymodules=loop modules-load=loop";
fi;
if test -f (loop)/arch/boot/intel_ucode.img; then
    set initrd_img="(loop)/arch/boot/intel_ucode.img ${initrd_img}"
fi;
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
